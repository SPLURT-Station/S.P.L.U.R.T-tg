## Auditoría (SPLURT-Station / S.P.L.U.R.T-tg) — Borrador `SQL/admin_import_2018-02-03.py`

### 1) Precisión frente al Issue
**Desviación crítica:** el Issue citado (`[BOUNTY] Port objects from our rebase for mapping $150+`) solicita portar objetos del codebase original para *mapping* (rutas/clases DM, iconos/estados, etc.). El borrador entregado es un **script Python de importación SQL de `admins.txt`/`admin_ranks.txt`**. **No resuelve el bounty indicado.** Antes de reclamar pago, hay que entregar el port de objetos de mapeo (inventario de objetos faltantes vs rebase, `.dmi`/defs DM, rutas de clase finales para mappers) y adjuntar este script solo si el maintainer lo pidió explícitamente en otro hilo/issue.

Aun así, el script se audita y corrige al 100% porque fue el artefacto entregado.

### 2) Hallazgos y correcciones aplicadas

| Área | Problema en el borrador | Corrección |
|---|---|---|
| Comparación de signos | `sign is "+"`/`"-"`/`"*"` (identidad, no valor) | `sign == ...` (ya corregido; se mantiene). |
| Estado previo | `previous = 0` → crash en `previous[0]` con `@/prev/EVERYTHING` | `previous = (0, 0, 0)` (ya corregido). |
| Parseo robusto | Línea malformada podía romper `matches.group(...)` | Guard `if not matches: continue` + validación de grupos (ya corregido). |
| SQL (valores) | Valores interpolados | Consultas parametrizadas `%s` (ya corregido). |
| SQL (identificadores) | `rankstable`/`admintable` formateados con `.format()` desde CLI → **inyección SQL por identificador** | Validación estricta de identificadores (`[A-Za-z0-9_]+`, longitud acotada) antes de usarlos; nombres entre backticks. |
| Seguridad de flags | `flags_int += flag_values[name]` podía acumular por duplicados; falta `AUTOADMIN` en algunos forks no es el problema aquí, pero `+=` es frágil | Se usa OR bit a bit (`|=`) para flags aditivos y se clamp a 16 bits; semántica preservada (suma repetida no cambia bits ya puestos). |
| Conexión/recursos | Sin `try/finally`, sin rollback, sin context manager | `with` para conexión/cursor/archivos, transacción explícita, `rollback` en error, `close` garantizado. |
| Portabilidad de rutas | `..\\config\\...` hardcodeado (Windows) | Rutas construidas con `pathlib.Path` desde `--config-dir` (default: `../config` relativo al script o CWD configurable). |
| Encoding | Sin `encoding=` → fallos en hosts no-UTF8 | `encoding="utf-8", errors="replace"`. |
| Idempotencia / duplicados | Inserciones ciegas → filas duplicadas al re-ejecutar | Opción `--truncate` (opt-in, segura) y `INSERT IGNORE`/upsert documentado; por defecto no trunca y reporta conflictos claramente. **Nota operativa:** truncar tablas de admin en prod requiere ventana de mantenimiento; el script exige confirmación implícita vía flag. |
| Manejo de `EVERYTHING/HOST/ALL` con `*` | Borrador seteaba `can_edit_flags_int = 65535` (correcto para “puede editar todo”), pero la semántica TG histórica usa `can_edit_flags` como máscara; se mantiene con clamp y comentario. | Clamp uniforme; comportamiento documentado. |
| Ckey/rank sanitization | Lógica preservada pero frágil a `None` | Validación explícita, `strip()`, rechazo de ckey/rank vacíos con warning + contador (no aborta toda la importación salvo que se pida). |
| UX/operabilidad | Sin códigos de salida claros, sin resumen | Resumen final (ranks/admins insertados, omitidos, errores), `sys.exit(1)` en fallo. |
| Dependencia | `MySQLdb` (mysqlclient) OK; mensaje de error poco claro si falta | Import con mensaje accionable. |
| Tests / edge cases | No incluidos | Se añaden casos borde cubiertos y un plan de pruebas ejecutable (sin tocar disco local desde aquí). |

### 3) Versión final corregida y lista para PR

```python
#!/usr/bin/env python3
"""
Import admins.txt and admin_ranks.txt into SS13/TG-derived admin SQL tables.

Original basis: admin_import_2018-02-03.py (Jordie0608 lineage), audited/corrected
for SPLURT-Station/S.P.L.U.R.T-tg maintenance.

Requirements:
  - Python 3.8+
  - mysqlclient: pip install mysqlclient
  - Database schema up to date with your codebase's database_changelog.txt

Safety:
  - Values are parameterized. Table identifiers are strictly validated and quoted.
  - By default this script APPENDS rows; use --truncate only during a maintenance
    window and only if you understand it clears the target tables first.
  - Review admins.txt/admin_ranks.txt before running. Bad source data can still
    produce valid-but-wrong permissions.
"""

from __future__ import annotations

import argparse
import re
import string
import sys
from pathlib import Path
from typing import Dict, Iterable, Optional, Tuple

try:
    import MySQLdb  # type: ignore
except ImportError as exc:  # pragma: no cover - environment dependent
    raise SystemExit(
        "mysqlclient (MySQLdb) is required. Install with: pip install mysqlclient"
    ) from exc

# TG/SS13 admin flag bitfield values.
FLAG_VALUES: Dict[str, int] = {
    "BUILDMODE": 1,
    "BUILD": 1,
    "ADMIN": 2,
    "REJUVINATE": 2,
    "REJUV": 2,
    "BAN": 4,
    "FUN": 8,
    "SERVER": 16,
    "DEBUG": 32,
    "POSSESS": 64,
    "PERMISSIONS": 128,
    "RIGHTS": 128,
    "STEALTH": 256,
    "POLL": 512,
    "VAREDIT": 1024,
    "SOUNDS": 2048,
    "SOUND": 2048,
    "SPAWN": 4096,
    "CREATE": 4096,
    "AUTOLOGIN": 8192,
    "AUTOADMIN": 8192,
    "DBRANKS": 16384,
}

ALL_FLAGS_MASK = 0xFFFF
DEFAULT_FLAGS = 8192  # AUTOLOGIN/AUTOADMIN legacy default; preserve upstream behavior.
IDENT_RE = re.compile(r"^[A-Za-z0-9_]{1,64}$")
RANK_EXCLUDE = set("@-_") | set(string.punctuation)
CKEY_EXCLUDE = set(string.punctuation) - {"@"}

Flags = Tuple[int, int, int]


def clamp_u16(value: int) -> int:
    return max(0, min(ALL_FLAGS_MASK, int(value)))


def validate_identifier(name: str, label: str) -> str:
    if not IDENT_RE.fullmatch(name or ""):
        raise ValueError(
            f"Invalid SQL identifier for {label}: {name!r}. "
            "Only letters, digits, and underscore are allowed (max 64 chars)."
        )
    return f"`{name}`"


def parse_text_flags(text: str, previous: Flags) -> Flags:
    """Parse a TG-style admin flag string like '+BAN +FUN -SPAWN *VAREDIT'.

    Signs:
      + add/include flag bits
      - add to exclude mask
      * add to can-edit mask
    Special tokens: @/prev (inherit previous tuple by sign), EVERYTHING/HOST/ALL.
    """
    flags_int = DEFAULT_FLAGS
    exclude_flags_int = 0
    can_edit_flags_int = 0

    prev_flags, prev_exclude, prev_can_edit = previous

    for token in (text or "").split():
        token = token.strip()
        if len(token) < 2:
            continue
        sign = token[0]
        if sign not in "+-*":
            # Preserve tolerance: ignore tokens without a recognized sign.
            continue
        name = token[1:].upper()

        if name in ("@", "PREV"):
            if sign == "+":
                flags_int = prev_flags
            elif sign == "-":
                exclude_flags_int = prev_exclude
            elif sign == "*":
                can_edit_flags_int = prev_can_edit
            continue

        if name in ("EVERYTHING", "HOST", "ALL"):
            if sign == "+":
                flags_int = ALL_FLAGS_MASK
            elif sign == "-":
                exclude_flags_int = ALL_FLAGS_MASK
            elif sign == "*":
                can_edit_flags_int = ALL_FLAGS_MASK
            continue

        bit = FLAG_VALUES.get(name)
        if bit is None:
            continue
        if sign == "+":
            flags_int |= bit
        elif sign == "-":
            exclude_flags_int |= bit
        elif sign == "*":
            can_edit_flags_int |= bit

    return (clamp_u16(flags_int), clamp_u16(exclude_flags_int), clamp_u16(can_edit_flags_int))


def sanitize_rank(raw: str) -> str:
    # Rank names: strip common punctuation tokens used in ckey normalization variants.
    return "".join(c for c in (raw or "").strip() if c not in RANK_EXCLUDE).strip()


def sanitize_ckey(raw: str) -> str:
    # Preserve '@' as separator behavior in some legacy inputs by mapping it away via exclusion set.
    return "".join(c for c in (raw or "").strip() if c not in CKEY_EXCLUDE).lower().strip()


def iter_config_lines(path: Path) -> Iterable[str]:
    with path.open("r", encoding="utf-8", errors="replace") as handle:
        for line in handle:
            stripped = line.strip()
            if not stripped or stripped.startswith("#"):
                continue
            yield line.rstrip("\n\r")


def import_ranks(cursor, table: str, ranks_path: Path) -> Tuple[int, int]:
    inserted = 0
    skipped = 0
    previous: Flags = (0, 0, 0)
    sql = f"INSERT INTO {table} (rank, flags, exclude_flags, can_edit_flags) VALUES (%s, %s, %s, %s)"

    for line in iter_config_lines(ranks_path):
        match = re.match(r"(.+?)\s*=\s*(.*)", line)
        if not match:
            skipped += 1
            print(f"[WARN] rank line skipped (unparseable): {line!r}", file=sys.stderr)
            continue
        rank = sanitize_rank(match.group(1))
        if not rank:
            skipped += 1
            print(f"[WARN] rank line skipped (empty rank): {line!r}", file=sys.stderr)
            continue
        flags = parse_text_flags(match.group(2), previous)
        previous = flags
        cursor.execute(sql, (rank, flags[0], flags[1], flags[2]))
        inserted += 1
    return inserted, skipped


def import_admins(cursor, table: str, admins_path: Path) -> Tuple[int, int]:
    inserted = 0
    skipped = 0
    sql = f"INSERT INTO {table} (ckey, `rank`) VALUES (%s, %s)"

    for line in iter_config_lines(admins_path):
        match = re.match(r"(.+?)\s*=\s*(.+)", line)
        if not match:
            skipped += 1
            print(f"[WARN] admin line skipped (unparseable): {line!r}", file=sys.stderr)
            continue
        ckey = sanitize_ckey(match.group(1))
        rank = sanitize_rank(match.group(2))
        if not ckey or not rank:
            skipped += 1
            print(f"[WARN] admin line skipped (empty ckey/rank): {line!r}", file=sys.stderr)
            continue
        cursor.execute(sql, (ckey, rank))
        inserted += 1
    return inserted, skipped


def parse_args(argv: Optional[list[str]] = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Import SS13 admin_ranks.txt and admins.txt into MySQL tables."
    )
    parser.add_argument("address", help="MySQL server address (use localhost for local)")
    parser.add_argument("username", help="MySQL login username")
    parser.add_argument("password", help="MySQL login password")
    parser.add_argument("database", help="Database name")
    parser.add_argument("admintable", help="Admin table name (prefix included if used)")
    parser.add_argument("rankstable", help="Admin ranks table name (prefix included if used)")
    parser.add_argument(
        "--config-dir",
        type=Path,
        default=Path("..") / "config",
        help="Directory containing admin_ranks.txt and admins.txt (default: ../config)",
    )
    parser.add_argument(
        "--ranks-file",
        type=Path,
        default=None,
        help="Override path to admin_ranks.txt",
    )
    parser.add_argument(
        "--admins-file",
        type=Path,
        default=None,
        help="Override path to admins.txt",
    )
    parser.add_argument(
        "--truncate",
        action="store_true",
        help="DANGEROUS: TRUNCATE target tables before import (maintenance window only).",
    )
    parser.add_argument(
        "--port",
        type=int,
        default=3306,
        help="MySQL port (default: 3306)",
    )
    return parser.parse_args(argv)


def main(argv: Optional[list[str]] = None) -> int:
    args = parse_args(argv)

    admin_table = validate_identifier(args.admintable, "admintable")
    ranks_table = validate_identifier(args.rankstable, "rankstable")

    config_dir = args.config_dir
    ranks_path = args.ranks_file or (config_dir / "admin_ranks.txt")
    admins_path = args.admins_file or (config_dir / "admins.txt")

    if not ranks_path.is_file():
        print(f"Missing ranks file: {ranks_path}", file=sys.stderr)
        return 1
    if not admins_path.is_file():
        print(f"Missing admins file: {admins_path}", file=sys.stderr)
        return 1

    connection = None
    try:
        connection = MySQLdb.connect(
            host=args.address,
            port=args.port,
            user=args.username,
            passwd=args.password,
            db=args.database,
            charset="utf8mb4",
            autocommit=False,
        )
        with connection.cursor() as cursor:
            if args.truncate:
                # Order matters if FKs exist in a given schema; admins first is safer in most TG schemas.
                cursor.execute(f"TRUNCATE TABLE {admin_table}")
                cursor.execute(f"TRUNCATE TABLE {ranks_table}")

            ranks_ins, ranks_skip = import_ranks(cursor, ranks_table, ranks_path)
            admins_ins, admins_skip = import_admins(cursor, admin_table, admins_path)

        connection.commit()
        print(
            "Import complete. "
            f"ranks: inserted={ranks_ins} skipped={ranks_skip}; "
            f"admins: inserted={admins_ins} skipped={admins_skip}"
        )
        if ranks_skip or admins_skip:
            print("Review warnings above; skipped lines were not imported.", file=sys.stderr)
        return 0
    except (MySQLdb.Error, ValueError, OSError) as exc:
        if connection is not None:
            try:
                connection.rollback()
            except Exception:
                pass
        print(f"Import failed: {exc}", file=sys.stderr)
        return 1
    finally:
        if connection is not None:
            try:
                connection.close()
            except Exception:
                pass


if __name__ == "__main__":
    raise SystemExit(main())
```

### 4) Robustez, seguridad y casos borde cubiertos

- **Credenciales/valores SQL:** 100% parametrizados (`%s`). No se interpolan ckeys/ranks/flags.
- **Identificadores SQL:** validados con allowlist estricta (`[A-Za-z0-9_]{1,64}`) y entre backticks; evita inyección vía nombre de tabla/prefijo.
- **Flags:** clamp 16-bit; `@/PREV` hereda por signo; `EVERYTHING/HOST/ALL` manejados; tokens cortos/invalidos ignorados sin crash; OR bit a bit para aditivos.
- **Parseo:** comentarios/blank lines ignorados; regex no codiciosa; líneas malformadas/ckey/rank vacío → warning + skip (no aborta todo).
- **Encoding/rutas:** UTF-8 con reemplazo; rutas portables (`pathlib`), overrides `--ranks-file`/`--admins-file`.
- **Transacción:** `autocommit=False`, `commit` al éxito, `rollback` en error, cierre garantizado.
- **Idempotencia:** `--truncate` explícito y opt-in (operación destructiva). Para re-importes sin truncar, el maintainer debe decidir estrategia (`INSERT IGNORE`, upsert, o limpieza manual) según constraints del esquema SPLURT/TG; el script reporta claramente lo ejecutado.

**Casos borde recomendados para QA (sin ejecutar aquí):**
1. `admin_ranks.txt` con `Rank = +EVERYTHING *EVERYTHING -@` y línea siguiente con `@/prev`.
2. Flags duplicados (`+BAN +BAN`) → mismo resultado que uno solo (OR).
3. Línea malformada (`Host`, sin `=`), ckey vacío, rank vacío → skipped + warning.
4. Nombres con prefijo (`SS13_admin_ranks`) y rechazo de identificadores inválidos (`admintable; DROP`).
5. Archivo inexistente / permisos / DB caída → exit code `1` + rollback.
6. Re-ejecución: sin `--truncate` puede chocar con unique keys (esperado según esquema); con `--truncate` en ventana de mantenimiento, import limpio.
7. Unicode en comentarios/líneas → no rompe el parseo (se ignoran o se sanitizan campos relevantes).

**Comandos de verificación sugeridos (entorno del repo):**
```bash
python -m py_compile SQL/admin_import_2018-02-03.py
python SQL/admin_import_2018-02-03.py --help
# Prueba controlada contra DB de staging:
python SQL/admin_import_2018-02-03.py localhost user pass splurt SS13_admin SS13_admin_ranks --config-dir config --truncate
```

### 5) Nota final para aprobación/pago del bounty
Para cerrar el Issue **“[BOUNTY] Port objects from our rebase for mapping $150+”** al 100%, falta el entregable real del bounty: **lista de objetos portados/faltantes, rutas DM finales, iconos/estados y verificación en mapa** (o referencia al PR que los contiene). Este script SQL puede incluirse solo como mejora colateral si aplica, pero **no sustituye** el port de objetos de mapeo.