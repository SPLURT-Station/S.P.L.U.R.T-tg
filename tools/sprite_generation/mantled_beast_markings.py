"""Generate Mantled Beast marking strips and DMI metadata.

The generated 128x32 strips use BYOND's 4-dir order:
South, North, East, West.
"""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

from PIL import Image, ImageDraw
from PIL.PngImagePlugin import PngInfo


TILE_SIZE = 32
DIRECTIONS = ("south", "north", "east", "west")

ROOT = Path(__file__).resolve().parents[2]
OUTPUT_DIR = ROOT / "modular_splurt" / "icons" / "mob" / "markings"
SOURCE_TAIL_DMI = ROOT / "modular_zubbers" / "icons" / "customization" / "kangarooalt.dmi"

BLACK = (0, 0, 0, 255)
WHITE = (255, 255, 255, 255)
TRANSPARENT = (0, 0, 0, 0)


@dataclass(frozen=True)
class DmiState:
    name: str
    dirs: int = 4
    frames: int = 1


def new_frame() -> Image.Image:
    return Image.new("RGBA", (TILE_SIZE, TILE_SIZE), TRANSPARENT)


def new_strip() -> Image.Image:
    return Image.new("RGBA", (TILE_SIZE * len(DIRECTIONS), TILE_SIZE), TRANSPARENT)


def paste_frames(frames: Iterable[Image.Image]) -> Image.Image:
    strip = new_strip()
    for index, frame in enumerate(frames):
        strip.alpha_composite(frame, (index * TILE_SIZE, 0))
    return strip


def draw_polygon(draw: ImageDraw.ImageDraw, outline: list[tuple[int, int]], inset: list[tuple[int, int]]) -> None:
    draw.polygon(outline, fill=BLACK)
    draw.polygon(inset, fill=WHITE)


def chest_diamond_strip() -> Image.Image:
    south = new_frame()
    draw = ImageDraw.Draw(south)
    draw_polygon(
        draw,
        outline=[(16, 10), (23, 17), (16, 25), (9, 17)],
        inset=[(16, 12), (20, 17), (16, 22), (12, 17)],
    )

    north = new_frame()

    east = new_frame()
    draw = ImageDraw.Draw(east)
    draw_polygon(
        draw,
        outline=[(21, 12), (26, 17), (21, 23), (17, 17)],
        inset=[(21, 14), (24, 17), (21, 20), (19, 17)],
    )

    west = new_frame()
    draw = ImageDraw.Draw(west)
    draw_polygon(
        draw,
        outline=[(11, 12), (15, 17), (11, 23), (6, 17)],
        inset=[(11, 14), (13, 17), (11, 20), (8, 17)],
    )

    return paste_frames((south, north, east, west))


def waist_stripe_strip() -> Image.Image:
    frames: list[Image.Image] = []
    for direction in DIRECTIONS:
        frame = new_frame()
        draw = ImageDraw.Draw(frame)
        if direction in ("south", "north"):
            draw.rectangle((8, 20, 23, 23), fill=BLACK)
            draw.point((7, 21), fill=BLACK)
            draw.point((24, 21), fill=BLACK)
        elif direction == "east":
            draw.rectangle((11, 20, 22, 23), fill=BLACK)
            draw.line((22, 21, 25, 22), fill=BLACK, width=2)
        else:
            draw.rectangle((9, 20, 20, 23), fill=BLACK)
            draw.line((6, 22, 9, 21), fill=BLACK, width=2)
        frames.append(frame)
    return paste_frames(frames)


def parse_dmi_states(path: Path) -> list[DmiState]:
    with Image.open(path) as icon:
        description = icon.info.get("Description", "")

    states: list[DmiState] = []
    current_name: str | None = None
    dirs = 1
    frames = 1

    for raw_line in description.splitlines():
        line = raw_line.strip()
        if line.startswith("state = "):
            if current_name is not None:
                states.append(DmiState(current_name, dirs, frames))
            current_name = line.split('"', 2)[1]
            dirs = 1
            frames = 1
        elif line.startswith("dirs = "):
            dirs = int(line.split("=", 1)[1].strip())
        elif line.startswith("frames = "):
            frames = int(line.split("=", 1)[1].strip())

    if current_name is not None:
        states.append(DmiState(current_name, dirs, frames))

    return states


def dmi_state_frames(path: Path, state_name: str) -> list[Image.Image]:
    with Image.open(path) as icon:
        source = icon.convert("RGBA")
        states = parse_dmi_states(path)

    columns = source.width // TILE_SIZE
    cell_index = 0
    for state in states:
        cell_count = state.dirs * state.frames
        if state.name == state_name:
            frames: list[Image.Image] = []
            for offset in range(cell_count):
                index = cell_index + offset
                x = (index % columns) * TILE_SIZE
                y = (index // columns) * TILE_SIZE
                frames.append(source.crop((x, y, x + TILE_SIZE, y + TILE_SIZE)))
            return frames
        cell_index += cell_count

    raise ValueError(f"State {state_name!r} was not found in {path}")


def combined_kangaroo_alt_frames() -> list[Image.Image] | None:
    if not SOURCE_TAIL_DMI.exists():
        return None

    try:
        behind = dmi_state_frames(SOURCE_TAIL_DMI, "m_tail_kangarooalt_BEHIND_primary")
        front = dmi_state_frames(SOURCE_TAIL_DMI, "m_tail_kangarooalt_FRONT_primary")
    except ValueError:
        return None

    combined: list[Image.Image] = []
    for behind_frame, front_frame in zip(behind, front):
        frame = new_frame()
        frame.alpha_composite(behind_frame)
        frame.alpha_composite(front_frame)
        combined.append(frame)
    return combined


def contour_stripe_from_mask(mask_frame: Image.Image) -> Image.Image:
    """Trace the top visible alpha contour from a Kangaroo Alt tail frame."""

    alpha = mask_frame.getchannel("A")
    points: list[tuple[int, int]] = []
    for x in range(TILE_SIZE):
        column = [y for y in range(TILE_SIZE) if alpha.getpixel((x, y)) > 24]
        if not column:
            continue
        top = min(column)
        bottom = max(column)
        if bottom - top < 2:
            continue
        points.append((x, top))

    stripe = new_frame()
    if len(points) < 2:
        return stripe

    draw = ImageDraw.Draw(stripe)
    for left, right in zip(points, points[1:]):
        if right[0] - left[0] > 2:
            continue
        draw.line((left, right), fill=WHITE, width=2)

    return stripe


def fallback_tail_frames() -> list[Image.Image]:
    frames: list[Image.Image] = []
    curves = (
        [(5, 24), (9, 25), (14, 24), (18, 21), (21, 17)],
        [(7, 22), (11, 24), (16, 25), (22, 24), (26, 22)],
        [(18, 24), (22, 22), (25, 18), (27, 14)],
        [(14, 24), (10, 22), (7, 18), (5, 14)],
    )
    for curve in curves:
        frame = new_frame()
        ImageDraw.Draw(frame).line(curve, fill=WHITE, width=2, joint="curve")
        frames.append(frame)
    return frames


def tail_stripe_strip() -> Image.Image:
    source_frames = combined_kangaroo_alt_frames()
    if source_frames:
        frames = [contour_stripe_from_mask(frame) for frame in source_frames]
    else:
        frames = fallback_tail_frames()
    return paste_frames(frames)


def dmi_description(states: Iterable[str]) -> str:
    lines = [
        "# BEGIN DMI",
        "version = 4.0",
        "\twidth = 32",
        "\theight = 32",
    ]
    for state in states:
        lines.extend(
            [
                f'state = "{state}"',
                "\tdirs = 4",
                "\tframes = 1",
            ]
        )
    lines.append("# END DMI")
    return "\n".join(lines) + "\n"


def write_dmi(strips: dict[str, Image.Image], output_path: Path) -> None:
    dmi = Image.new("RGBA", (TILE_SIZE * len(DIRECTIONS), TILE_SIZE * len(strips)), TRANSPARENT)
    for index, strip in enumerate(strips.values()):
        dmi.alpha_composite(strip, (0, index * TILE_SIZE))

    metadata = PngInfo()
    metadata.add_text("Description", dmi_description(strips.keys()))
    dmi.save(output_path, format="PNG", pnginfo=metadata)


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    strips = {
        "chest_diamond": chest_diamond_strip(),
        "waist_stripe": waist_stripe_strip(),
        "tail_stripe": tail_stripe_strip(),
    }

    for state_name, strip in strips.items():
        strip.save(OUTPUT_DIR / f"{state_name}.png")

    write_dmi(strips, OUTPUT_DIR / "mantled_beast_markings.dmi")


if __name__ == "__main__":
    main()
