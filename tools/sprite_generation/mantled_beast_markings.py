"""Generate Mantled Beast marking strips and DMI metadata.

The PNG strips are 128x32, with BYOND's four directions ordered as:
South, North, East, West.
"""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw
from PIL.PngImagePlugin import PngInfo


TILE_SIZE = 32
STRIP_WIDTH = TILE_SIZE * 4

ROOT_DIR = Path(__file__).resolve().parents[2]
OUTPUT_DIR = ROOT_DIR / "modular_splurt" / "icons" / "mob" / "markings"

BLACK = (0, 0, 0, 255)
WHITE = (255, 255, 255, 255)
TRANSPARENT = (0, 0, 0, 0)

DMI_MANIFEST = (
    "# BEGIN DMI\n"
    "version = 4.0\n"
    "\twidth = 32\n"
    "\theight = 32\n"
    'state = "chest_diamond"\n'
    "\tdirs = 4\n"
    "\tframes = 1\n"
    'state = "waist_stripe"\n'
    "\tdirs = 4\n"
    "\tframes = 1\n"
    'state = "tail_stripe"\n'
    "\tdirs = 4\n"
    "\tframes = 1\n"
    "# END DMI\n"
)


def new_frame() -> Image.Image:
    return Image.new("RGBA", (TILE_SIZE, TILE_SIZE), TRANSPARENT)


def stitch_frames(frames: tuple[Image.Image, Image.Image, Image.Image, Image.Image]) -> Image.Image:
    strip = Image.new("RGBA", (STRIP_WIDTH, TILE_SIZE), TRANSPARENT)
    for index, frame in enumerate(frames):
        strip.alpha_composite(frame, (index * TILE_SIZE, 0))
    return strip


def draw_diamond(draw: ImageDraw.ImageDraw, outline: list[tuple[int, int]], inset: list[tuple[int, int]]) -> None:
    draw.polygon(outline, fill=BLACK)
    draw.polygon(inset, fill=WHITE)


def draw_chest_s() -> Image.Image:
    frame = new_frame()
    draw_diamond(
        ImageDraw.Draw(frame),
        outline=[(16, 10), (23, 17), (16, 25), (9, 17)],
        inset=[(16, 12), (20, 17), (16, 22), (12, 17)],
    )
    return frame


def draw_chest_n() -> Image.Image:
    return new_frame()


def draw_chest_e() -> Image.Image:
    frame = new_frame()
    draw_diamond(
        ImageDraw.Draw(frame),
        outline=[(21, 12), (26, 17), (21, 23), (17, 17)],
        inset=[(21, 14), (24, 17), (21, 20), (19, 17)],
    )
    return frame


def draw_chest_w() -> Image.Image:
    frame = new_frame()
    draw_diamond(
        ImageDraw.Draw(frame),
        outline=[(11, 12), (15, 17), (11, 23), (6, 17)],
        inset=[(11, 14), (13, 17), (11, 20), (8, 17)],
    )
    return frame


def draw_waist_s() -> Image.Image:
    frame = new_frame()
    draw = ImageDraw.Draw(frame)
    draw.rectangle((8, 20, 23, 23), fill=BLACK)
    draw.point((7, 21), fill=BLACK)
    draw.point((24, 21), fill=BLACK)
    return frame


def draw_waist_n() -> Image.Image:
    frame = new_frame()
    draw = ImageDraw.Draw(frame)
    draw.rectangle((8, 20, 23, 23), fill=BLACK)
    draw.point((7, 21), fill=BLACK)
    draw.point((24, 21), fill=BLACK)
    return frame


def draw_waist_e() -> Image.Image:
    frame = new_frame()
    draw = ImageDraw.Draw(frame)
    draw.rectangle((11, 20, 22, 23), fill=BLACK)
    draw.line((22, 21, 25, 22), fill=BLACK, width=2)
    return frame


def draw_waist_w() -> Image.Image:
    frame = new_frame()
    draw = ImageDraw.Draw(frame)
    draw.rectangle((9, 20, 20, 23), fill=BLACK)
    draw.line((6, 22, 9, 21), fill=BLACK, width=2)
    return frame


def draw_tail_s() -> Image.Image:
    frame = new_frame()
    ImageDraw.Draw(frame).point(
        [(3, 28), (2, 29), (3, 29), (4, 29), (3, 30)],
        fill=WHITE,
    )
    return frame


def draw_tail_n() -> Image.Image:
    frame = new_frame()
    ImageDraw.Draw(frame).point(
        [
            (14, 20), (16, 20),
            (13, 21), (14, 21), (15, 21), (16, 21), (17, 21),
            (12, 22), (13, 22), (14, 22), (16, 22), (17, 22), (18, 22),
            (13, 23), (17, 23), (18, 23),
            (18, 24), (19, 24),
            (19, 25),
            (19, 26), (20, 26),
            (20, 27),
            (20, 28), (21, 28), (22, 28), (28, 28),
            (20, 29), (21, 29), (22, 29), (23, 29), (27, 29), (28, 29), (29, 29),
            (22, 30), (23, 30), (28, 30),
        ],
        fill=WHITE,
    )
    return frame


def draw_tail_e() -> Image.Image:
    frame = new_frame()
    ImageDraw.Draw(frame).point(
        [
            (9, 19), (10, 19), (11, 19),
            (8, 20), (9, 20), (10, 20), (11, 20),
            (7, 21), (8, 21), (9, 21), (11, 21), (12, 21),
            (7, 22), (8, 22), (11, 22), (12, 22),
            (6, 23), (7, 23),
            (6, 24),
            (5, 25), (6, 25),
            (0, 26), (1, 26), (2, 26), (3, 26), (5, 26),
            (0, 27), (1, 27), (2, 27), (3, 27), (4, 27), (5, 27),
            (0, 28), (3, 28), (4, 28), (5, 28),
            (2, 29), (3, 29), (4, 29),
            (3, 30),
        ],
        fill=WHITE,
    )
    return frame


def draw_tail_w() -> Image.Image:
    frame = new_frame()
    ImageDraw.Draw(frame).point(
        [
            (20, 19), (21, 19), (22, 19),
            (20, 20), (21, 20), (22, 20), (23, 20),
            (19, 21), (20, 21), (22, 21), (23, 21), (24, 21),
            (19, 22), (20, 22), (23, 22), (24, 22),
            (24, 23), (25, 23),
            (25, 24),
            (25, 25), (26, 25),
            (26, 26), (28, 26), (29, 26), (30, 26), (31, 26),
            (26, 27), (27, 27), (28, 27), (29, 27), (30, 27), (31, 27),
            (26, 28), (27, 28), (28, 28), (31, 28),
            (27, 29), (28, 29), (29, 29),
            (28, 30),
        ],
        fill=WHITE,
    )
    return frame


def build_chest_diamond() -> Image.Image:
    return stitch_frames((draw_chest_s(), draw_chest_n(), draw_chest_e(), draw_chest_w()))


def build_waist_stripe() -> Image.Image:
    return stitch_frames((draw_waist_s(), draw_waist_n(), draw_waist_e(), draw_waist_w()))


def build_tail_stripe() -> Image.Image:
    return stitch_frames((draw_tail_s(), draw_tail_n(), draw_tail_e(), draw_tail_w()))


def save_dmi(strips: tuple[tuple[str, Image.Image], tuple[str, Image.Image], tuple[str, Image.Image]]) -> None:
    dmi_image = Image.new("RGBA", (STRIP_WIDTH, TILE_SIZE * len(strips)), TRANSPARENT)
    for row, (_, strip) in enumerate(strips):
        dmi_image.alpha_composite(strip, (0, row * TILE_SIZE))

    metadata = PngInfo()
    metadata.add_text("Description", DMI_MANIFEST)
    dmi_image.save(OUTPUT_DIR / "mantled_beast_markings.dmi", format="PNG", pnginfo=metadata)


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    strips = (
        ("chest_diamond", build_chest_diamond()),
        ("waist_stripe", build_waist_stripe()),
        ("tail_stripe", build_tail_stripe()),
    )

    for state_name, strip in strips:
        strip.save(OUTPUT_DIR / f"{state_name}.png", format="PNG")

    save_dmi(strips)


if __name__ == "__main__":
    main()
