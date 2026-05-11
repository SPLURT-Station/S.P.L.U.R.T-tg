# Modular tgui overlays

This module lets downstream code change tgui at build time without keeping those
changes directly in upstream-owned `tgui/` source files.

The repo's `tgui/package.json` scripts dispatch through this module:

```sh
bun run tgui:build
bun run tgui:dev
bun run tgui:analyze
```

The wrapper Rspack config installs `ModularTguiOverlayPlugin`, which emits
generated sources under `tgui/node_modules/.bun/node_modules/.cache/` when Bun's
active dependency links are available, falling back to
`tgui/node_modules/.cache/`. Those generated sources are what Rspack builds.

## Layout

The base module lives at:

```txt
modular_zzplurt/modules/tgui_modular
```

Feature override manifests should usually live outside that base module. The
current default scan root is:

```txt
modular_zzplurt/tgui/unsorted-autogenned
```

That folder currently contains generated manifests for branch tgui edits. Move
or split generated files into feature folders when you know their ownership.

## Scan Roots

`manifest.ts` controls which folders are scanned for modular tgui files:

```ts
export const scanRoots = [
	// Only scan files directly in this folder.
	{ path: '../../tgui/my_feature', recursive: false },

	// Scan this folder and every child folder.
	{ path: '../../tgui/shared_overlays', recursive: true },
];
```

Paths are relative to `modular_zzplurt/modules/tgui_modular` unless absolute.
Only files ending in `.tgui.ts`, `.tgui.tsx`, `.tgui.js`, or `.tgui.jsx` are
loaded. Scanned files must opt in with `export const modularTgui = true`.

```ts
import { block, type ModularTguiPatch } from '../../modules/tgui_modular';
import type { ModularTguiOverride } from '../../modules/tgui_modular';

export const modularTgui = true;

export const overrides: ModularTguiOverride[] = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PreferencesMenu/types.ts',
		operations: [
			{
				kind: 'ast-add-type-member',
				typeName: 'PreferencesMenuData',
				content: block`
					extra_panel_state: string;
				`,
			},
		],
	},
];
```

Files in a scan folder are loaded alphabetically. Recursive scans load the
current folder first, then child folders alphabetically. Patch operations still
run in the order they are listed.

If multiple scanned files touch the same tgui target, they are composed in scan
order. A whole-file override replaces the current working source for that
target, later patches apply on top of that replacement, and later whole-file
overrides for the same target replace earlier work.

## Whole-file Overrides

Use an override when a file is heavily downstream-owned, or when small patches
would be harder to understand than a complete replacement.

```ts
export const overrides: ModularTguiOverride[] = [
	{
		target: 'packages/tgui/interfaces/PreferencesMenu/types.ts',
		replacement: 'overrides/PreferencesMenu/types.ts',
	},
];
```

`target` is relative to `tgui/`. `replacement` is relative to the manifest file
that declares it. The replacement file must provide the exports callers expect
from the original file.

The redirect works for relative imports such as `./types`, package aliases such
as `tgui/backend`, and extensionless imports. Relative imports inside generated
or replacement files are resolved back through the original tgui tree when
needed, so generated patch files can still import neighboring upstream files.

## Source Patches

Use patches when the upstream file should mostly stay intact, but the built
bundle needs downstream edits.

Patch targets are relative to `tgui/`. Patch operations run in order:

```ts
export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PreferencesMenu/types.ts',
		operations: [
			{
				kind: 'ast-add-type-member',
				typeName: 'PreferencesMenuData',
				content: 'extra_panel_state: string;',
			},
		],
	},
];
```

Prefer `ast-*` operations when they fit. They parse TypeScript/TSX and target
code structure, so they are less sensitive to upstream formatting changes.
Plain text operations are still useful escape hatches, but they are more fragile
and can fail at build time if upstream rewrites nearby text.

Use `block` for multiline content in TypeScript manifests. It strips one common
tab indent from the template, which keeps manifests readable without repeating
quotes on every line.

## AST Operations

### Add imports

Adds named imports to an existing import from the same module, or creates a new
import when the module is missing.

```ts
{
	kind: 'ast-add-import',
	module: './downstream/ExtraPanel',
	imports: ['ExtraPanel'],
}
```

Use `typeOnly: true` for `import type`.

### Remove import specifiers

```ts
{
	kind: 'ast-remove-import-specifier',
	module: '../../base',
	imports: ['FeatureToggle'],
}
```

### Add or remove type members

Works with named exported `type` literals and `interface` declarations.

```ts
{
	kind: 'ast-add-type-member',
	typeName: 'PreferencesMenuData',
	content: 'extra_panel_state: string;',
}
```

```ts
{
	kind: 'ast-remove-type-member',
	typeName: 'CharacterPreferencesData',
	members: ['silicon_preferences'],
}
```

### Add array or object entries

Targets named variables with array or object initializers.

```ts
{
	kind: 'ast-add-array-item',
	variableName: 'tabs',
	content: 'extraTab,',
}
```

```ts
{
	kind: 'ast-add-object-entry',
	variableName: 'pages',
	content: 'Extra: ExtraPage,',
}
```

### Wrap a function component

Renames an exported function component, then appends your wrapper export.

```ts
{
	kind: 'ast-wrap-function-component',
	exportName: 'PreferencesMenu',
	innerName: 'BasePreferencesMenu',
	wrapper: block`
		export function PreferencesMenu() {
			return <PreferenceShell content={<BasePreferencesMenu />} />;
		}
	`,
}
```

### Add enum members

```ts
{
	kind: 'ast-add-enum-member',
	enumName: 'Page',
	content: 'CyborgCharacter,',
}
```

```ts
{
	kind: 'ast-remove-enum-member',
	enumName: 'Page',
	memberName: 'Silicon',
}
```

### Add or remove switch cases

```ts
{
	kind: 'ast-add-switch-case',
	switchExpression: 'currentPage',
	afterCase: 'Page.Main',
	content: block`
		case Page.CyborgCharacter:
			pageContents = <CyborgCharacterPage />;
			break;
	`,
}
```

```ts
{
	kind: 'ast-remove-switch-case',
	switchExpression: 'currentPage',
	caseExpression: 'Page.Silicon',
}
```

### Replace a variable initializer

```ts
{
	kind: 'ast-replace-variable-initializer',
	variableName: 'mainFeatures',
	content: "['clothing'].filter(Boolean)",
}
```

### Add destructured properties

Finds an object destructuring variable declaration by initializer text.

```ts
{
	kind: 'ast-add-destructured-properties',
	sourceExpression: 'data',
	afterProperty: 'shuttleRecallable',
	properties: ['canManageSecurityCyborgs', 'securityCyborgs'],
}
```

### Add statements to a function body

Targets a function declaration, function expression variable, or arrow function
variable by name.

```ts
{
	kind: 'ast-add-function-body-statement',
	functionName: 'PageMain',
	position: 'before-return',
	content: 'const ready = true;',
}
```

`position` may be `after-start` or `before-return`.

### Add JSX children

Finds a matching JSX element and inserts a child before its closing tag.

```ts
{
	kind: 'ast-add-jsx-child',
	functionName: 'PageMain',
	componentName: 'Flex',
	propName: 'direction',
	propValue: 'column',
	containingText: 'Existing child text',
	content: '<Button>Extra Action</Button>',
}
```

`functionName`, `propName`, `propValue`, and `containingText` are optional
filters, but the operation must resolve to exactly one JSX element.

## Text Operations

These are plain text operations. Prefer AST operations when possible.

```ts
{ kind: 'insert', anchor: 'text', position: 'before', content: '...' }
{ kind: 'insert', anchor: 'text', position: 'after', content: '...' }
{ kind: 'replace', anchor: 'text', content: '...' }
{ kind: 'replace-all', anchor: 'old', content: 'new' }
{ kind: 'prepend', content: '...' }
{ kind: 'append', content: '...' }
```

`insert`, `replace`, and `replace-all` accept `expectedOccurrences`.

The older semantic text helpers are also available:

```ts
{ kind: 'add-import', content: "import { Extra } from './Extra';" }
{ kind: 'add-type-member', typeName: 'Data', content: 'extra: string;' }
{ kind: 'add-array-item', anchor: 'const tabs =', content: 'extraTab,' }
{ kind: 'add-object-entry', anchor: 'const pages =', content: 'Extra: ExtraPage,' }
{ kind: 'wrap-function-component', exportName: 'Panel', innerName: 'BasePanel', wrapper: '...' }
```

## Tools

Run these from the `tgui/` directory unless noted.

### Test and build

```sh
bun ../modular_zzplurt/modules/tgui_modular/tools/cli.ts test
bun run tgui:build
bun run tgui:dev
bun run tgui:analyze
```

### Compare generated output against a ref

Use this when a git ref still contains the old direct tgui edits:

```sh
bun ../modular_zzplurt/modules/tgui_modular/tools/cli.ts compare HEAD
```

Diff files are written under:

```txt
tgui/node_modules/.bun/node_modules/.cache/tgui_modular_compare/
```

### Create one modular edit

Compares upstream source against the current local tgui file.

```sh
bun ../modular_zzplurt/modules/tgui_modular/tools/cli.ts create-override \
	--target packages/tgui/interfaces/Example.tsx \
	--out-dir ../modular_zzplurt/tgui/my_feature \
	--upstream-ref upstream/master
```

`--upstream-url` may be used instead of `--upstream-ref` for a GitHub repo or
raw-content base URL.

The tool first tries to infer safe AST and small text patches, then checks that
the operations reproduce the local file exactly. Text hunk inference uses
different limits for inserts, deletes, and replacements: large additive hunks
are allowed, but broad rewrites still fall back to whole-file overrides. If no
patch can be proven exact, it writes a whole-file override and prints a warning.

### Generate final runtime source

Writes or prints what Rspack will see after modular overrides and patches.

```sh
bun ../modular_zzplurt/modules/tgui_modular/tools/cli.ts generate-final \
	--target packages/tgui/interfaces/Example.tsx \
	--out /tmp/Example.final.tsx
```

Omit `--out` to print the generated source to stdout.

### Migrate modified tgui files

```sh
bun ../modular_zzplurt/modules/tgui_modular/tools/cli.ts migrate-overrides \
	--out-dir ../modular_zzplurt/tgui/my_feature \
	--upstream-ref upstream/master
```

Use `--targets a.tsx,b.tsx` to migrate only specific tgui targets.

For each file, the migrator saves a temporary copy of the local final source,
writes a modular patch or override, restores the local tgui file to upstream
source, generates the modular runtime result, and verifies it matches the
temporary copy before moving on.

## Notes

- New tgui interfaces generally do not need an override. Put the file under
  `packages/tgui/interfaces`; route discovery already picks them up.
- Replacement files and generated patch files must still import dependencies
  that they use.
- If a patch fails during build, first run `generate-final` for that target to
  see the composed source, then use `compare HEAD` when you need a diff against
  an older direct-edit ref.
