import argparse
import os
import struct
import sys
import zlib
from io import BytesIO

from PIL import Image
import numpy as np


def seamless_shift(img: Image.Image, dx: int, dy: int) -> Image.Image:
    arr = np.array(img)
    arr = np.roll(arr, dy, axis=0)
    arr = np.roll(arr, dx, axis=1)
    return Image.fromarray(arr)


def generate_animation_frames(
    img: Image.Image, dx: int, dy: int, frames: int, size: int
) -> list[Image.Image]:
    frame_list = []
    for i in range(frames):
        offset_x = (dx * i) % size
        offset_y = (dy * i) % size
        frame = seamless_shift(img, offset_x, offset_y)
        frame_list.append(frame)
    return frame_list


def save_png_with_ztxt(img: Image.Image, key: str, text: str, path: str):
    buf = BytesIO()
    img.save(buf, format="PNG")
    png_bytes = buf.getvalue()

    pos = 8
    while True:
        if pos >= len(png_bytes):
            raise ValueError("IHDR not found in PNG")
        chunk_len = struct.unpack(">I", png_bytes[pos : pos + 4])[0]
        chunk_type = png_bytes[pos + 4 : pos + 8]
        if chunk_type == b"IHDR":
            after_ihdr_pos = pos + 4 + 4 + chunk_len + 4
            break
        pos += 4 + 4 + chunk_len + 4

    keyword = key.encode("ascii") + b"\0"
    comp_method = b"\0"
    compressed = zlib.compress(text.encode("utf-8"), level=6)
    payload = keyword + comp_method + compressed

    chunk_len_b = struct.pack(">I", len(payload))
    chunk_type_b = b"zTXt"
    crc_input = chunk_type_b + payload
    crc = struct.pack(">I", zlib.crc32(crc_input) & 0xFFFFFFFF)

    ztxt_chunk = chunk_len_b + chunk_type_b + payload + crc

    new_png = png_bytes[:after_ihdr_pos] + ztxt_chunk + png_bytes[after_ihdr_pos:]

    with open(path, "wb") as f:
        f.write(new_png)


def create_dmi(
    state_data: list[tuple[str, list[Image.Image], float]],
    icon_size: int,
    output_path: str,
):
    if not state_data:
        return

    total_frames = sum(len(frames) for _, frames, _ in state_data)
    big_height = icon_size * total_frames
    big_img = Image.new("RGBA", (icon_size, big_height))

    y = 0
    for _, frame_list, _ in state_data:
        for frame in frame_list:
            big_img.paste(frame, (0, y))
            y += icon_size

    dmi_desc = "# BEGIN DMI\nversion = 4.0\n"
    dmi_desc += f"width = {icon_size}\nheight = {icon_size}\n"

    for state_name, frame_list, state_delay in state_data:
        frame_count = len(frame_list)

        dmi_desc += f'state = "{state_name}"\n'
        dmi_desc += "\tdirs = 1\n"
        dmi_desc += f"\tframes = {frame_count}\n"

        if frame_count > 1:
            delay_str = ",".join([str(state_delay)] * frame_count)
            dmi_desc += f"\tdelay = {delay_str}\n"

    dmi_desc += "# END DMI\n"

    save_png_with_ztxt(big_img, "Description", dmi_desc, output_path)


def process_single_tile(
    input_path: str, output_dir: str, dx: int, dy: int, speed: int, frames: int, frame_delay: int
):
    img = Image.open(input_path).convert("RGBA")
    size = img.width
    if img.height != size:
        raise ValueError("The tile must be square!")

    dx *= speed
    dy *= speed

    print(f"🎨 Creating {frames} movement frames (speed {speed})...")

    frame_list = generate_animation_frames(img, dx, dy, frames, size)

    sprite_sheet = Image.new("RGBA", (frames * size, size))
    for i, frame in enumerate(frame_list):
        sprite_sheet.paste(frame, (i * size, 0))
    sprite_sheet.save(os.path.join(output_dir, "animation_sheet.png"))

    frame_list[0].save(
        os.path.join(output_dir, "preview.gif"),
        save_all=True,
        append_images=frame_list[1:],
        duration=40,
        loop=0,
    )

    base_name = os.path.splitext(os.path.basename(input_path))[0]
    dmi_path = os.path.join(output_dir, f"{base_name}_flow.dmi")
    create_dmi(
        [
            (f"{base_name}_still", [img], 1),
            (base_name, frame_list, frame_delay),
        ],
        size,
        dmi_path,
    )

    print(f"✅ Done! Everything saved to folder: {output_dir}")
    print(f" 🗂️  BYOND: {os.path.basename(dmi_path)}")


def process_folder(
    input_path: str, output_dir: str, dx: int, dy: int, speed: int, frames: int, frame_delay: int
):
    png_files = sorted(
        [os.path.join(input_path, f) for f in os.listdir(input_path) if f.lower().endswith(".png")]
    )
    if not png_files:
        raise ValueError("There are no PNG files in the folder!")

    print(f"📁 Found {len(png_files)} tiles...")

    state_data = []
    first_size = None

    for png_path in png_files:
        img = Image.open(png_path).convert("RGBA")
        size = img.width
        if img.height != size:
            raise ValueError(f"Tile {os.path.basename(png_path)} must be square!")

        if first_size is None:
            first_size = size
        elif size != first_size:
            raise ValueError("All tiles must be the same size!")

        dx_speed = dx * speed
        dy_speed = dy * speed

        frame_list = generate_animation_frames(img, dx_speed, dy_speed, frames, size)

        state_name = os.path.splitext(os.path.basename(png_path))[0]
        state_data.append((f"{state_name}_still", [img], 1))
        state_data.append((state_name, frame_list, frame_delay))
        sub_dir = os.path.join(output_dir, f"{state_name}_flow")
        os.makedirs(sub_dir, exist_ok=True)

        sprite_sheet = Image.new("RGBA", (frames * size, size))
        for i, frame in enumerate(frame_list):
            sprite_sheet.paste(frame, (i * size, 0))
        sprite_sheet.save(os.path.join(sub_dir, "animation_sheet.png"))

        frame_list[0].save(
            os.path.join(sub_dir, "preview.gif"),
            save_all=True,
            append_images=frame_list[1:],
            duration=40,
            loop=0,
        )

        state_data.append((state_name, frame_list, frame_delay))

    dmi_path = os.path.join(output_dir, f"{os.path.basename(os.path.normpath(input_path))}_flow.dmi")
    create_dmi(state_data, frames, first_size, dmi_path)

    print(f"✅ Done! .dmi created: {os.path.basename(dmi_path)}")


def auto_mode():
    """Automatic mode without parameters"""
    current_dir = os.getcwd()
    input_path = os.path.join(current_dir, "input")
    output_dir = os.path.join(current_dir, "output")

    if not os.path.isdir(input_path):
        raise ValueError(f"'input' folder not found!\nExpected path: {input_path}")

    os.makedirs(output_dir, exist_ok=True)

    print("🚀 Auto mode: processing 'input' folder → 'output' with three speeds...")

    png_files = sorted(
        [os.path.join(input_path, f) for f in os.listdir(input_path) if f.lower().endswith(".png")]
    )
    if not png_files:
        raise ValueError("There are no PNG files in the 'input' folder!")

    variants = [
        ("moving", 2, 0.1)
    ]

    state_data = []
    first_size = None
    frames = 32
    dx, dy = -1, 0  # right

    for png_path in png_files:
        img = Image.open(png_path).convert("RGBA")
        size = img.width
        if img.height != size:
            raise ValueError(f"Tile {os.path.basename(png_path)} must be square!")

        if first_size is None:
            first_size = size
        elif size != first_size:
            raise ValueError("All tiles must be the same size!")

        state_base = os.path.splitext(os.path.basename(png_path))[0]

        for suffix, var_speed, var_delay in variants:
            dx_s = dx * var_speed
            dy_s = dy * var_speed
            frame_list = generate_animation_frames(img, dx_s, dy_s, frames, size)
            full_name = f"{state_base}_{suffix}"
            state_data.append((f"{state_base}_still", [img], 1))
            state_data.append((full_name, frame_list, var_delay))

    dmi_path = os.path.join(output_dir, "tiles_flow.dmi")
    create_dmi(state_data, first_size, dmi_path)

if __name__ == "__main__":
    if len(sys.argv) == 1:  # Run without parameters → auto mode
        auto_mode()
    else:
        # Normal mode with arguments
        parser = argparse.ArgumentParser(
            description="Seamless tile animation + export to BYOND .dmi"
        )
        parser.add_argument("input", help="Path to a PNG tile OR a folder of PNG tiles")
        parser.add_argument("-d", "--direction", default="down", help="Direction...")
        parser.add_argument("-s", "--speed", type=int, default=1, help="Shift speed")
        parser.add_argument("-f", "--frames", type=int, default=32, help="Number of frames")
        parser.add_argument("-fd", "--frame-delay", type=int, default=1, help="Frame delay in .dmi")
        parser.add_argument("-o", "--output", help="Folder to save to")

        args = parser.parse_args()

        dir_map = {
            "right": (1, 0), "left": (-1, 0), "down": (0, 1), "up": (0, -1),
            "down_right": (1, 1), "down_left": (-1, 1),
            "up_right": (1, -1), "up_left": (-1, -1),
        }
        d_str = args.direction.lower().replace(" ", "_").replace("-", "_")
        if d_str in dir_map:
            dx, dy = dir_map[d_str]
        else:
            try:
                parts = [int(x) for x in d_str.replace(",", " ").split() if x]
                dx = parts[0]
                dy = parts[1] if len(parts) > 1 else 0
            except:
                raise ValueError(f"Unknown direction '{args.direction}'.")

        if args.output is None:
            if os.path.isdir(args.input):
                base = os.path.basename(os.path.normpath(args.input))
            else:
                base = os.path.splitext(os.path.basename(args.input))[0]
            output_dir = f"{base}_flow_{d_str}"
        else:
            output_dir = args.output
        os.makedirs(output_dir, exist_ok=True)

        if os.path.isfile(args.input) and args.input.lower().endswith(".png"):
            process_single_tile(
                args.input, output_dir, dx, dy, args.speed, args.frames, args.frame_delay
            )
        elif os.path.isdir(args.input):
            process_folder(
                args.input, output_dir, dx, dy, args.speed, args.frames, args.frame_delay
            )
        else:
            raise ValueError("Specify a PNG file or a folder of PNG files!")
