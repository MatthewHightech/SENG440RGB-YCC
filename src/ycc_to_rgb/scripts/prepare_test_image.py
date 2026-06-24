#!/usr/bin/env python3
"""Build a 64x48 PPM test image from course .data/.raw or a PNG/JPEG."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path

IMAGE_ROWS = 64
IMAGE_COLS = 48
PIXELS = IMAGE_ROWS * IMAGE_COLS


def write_ppm(path: Path, rgb: bytes) -> None:
    if len(rgb) != PIXELS * 3:
        raise ValueError(
            f"expected {PIXELS * 3} bytes of RGB data, got {len(rgb)}"
        )
    path.parent.mkdir(parents=True, exist_ok=True)
    header = f"P6\n{IMAGE_COLS} {IMAGE_ROWS}\n255\n".encode("ascii")
    path.write_bytes(header + rgb)


def read_interleaved_rgb(path: Path) -> bytes:
    data = path.read_bytes()
    if len(data) != PIXELS * 3:
        raise ValueError(
            f"{path}: expected {PIXELS * 3} bytes, found {len(data)}"
        )
    return data


def resize_with_pillow(path: Path) -> bytes:
    try:
        from PIL import Image
    except ImportError as exc:
        raise RuntimeError(
            "install Pillow (`pip install pillow`) or use ffmpeg to resize images"
        ) from exc

    with Image.open(path) as image:
        resized = image.convert("RGB").resize(
            (IMAGE_COLS, IMAGE_ROWS), Image.Resampling.LANCZOS
        )
        return resized.tobytes()


def resize_with_ffmpeg(path: Path) -> bytes:
    command = [
        "ffmpeg",
        "-y",
        "-i",
        str(path),
        "-vf",
        f"scale={IMAGE_COLS}:{IMAGE_ROWS}",
        "-pix_fmt",
        "rgb24",
        "-f",
        "rawvideo",
        "pipe:1",
    ]
    result = subprocess.run(
        command, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    if len(result.stdout) != PIXELS * 3:
        raise RuntimeError(
            f"ffmpeg produced {len(result.stdout)} bytes, expected {PIXELS * 3}"
        )
    return result.stdout


def load_source(path: Path) -> bytes:
    suffix = path.suffix.lower()
    if suffix in {".data", ".raw"}:
        return read_interleaved_rgb(path)
    if suffix == ".ppm":
        return read_interleaved_rgb_from_ppm(path)
    if suffix in {".png", ".jpg", ".jpeg", ".bmp", ".gif", ".webp"}:
        try:
            return resize_with_pillow(path)
        except RuntimeError:
            return resize_with_ffmpeg(path)
    raise RuntimeError(
        f"unsupported input format: {path.suffix} "
        "(use .data, .raw, .ppm, .png, or .jpg)"
    )


def read_interleaved_rgb_from_ppm(path: Path) -> bytes:
    with path.open("rb") as handle:
        magic = handle.read(2)
        if magic != b"P6":
            raise ValueError(f"{path}: expected binary PPM (P6)")

        tokens: list[str] = []
        while len(tokens) < 3:
            chunk = handle.read(1)
            if not chunk:
                raise ValueError(f"{path}: truncated PPM header")
            if chunk.startswith(b"#"):
                handle.readline()
                continue
            if chunk.isspace():
                continue
            token = chunk
            while True:
                next_byte = handle.read(1)
                if not next_byte or next_byte.isspace():
                    break
                token += next_byte
            tokens.append(token.decode("ascii"))

        width, height, maxval = map(int, tokens)
        if width != IMAGE_COLS or height != IMAGE_ROWS:
            raise ValueError(
                f"{path}: expected {IMAGE_COLS}x{IMAGE_ROWS}, got {width}x{height}"
            )
        if maxval != 255:
            raise ValueError(f"{path}: only 8-bit PPM is supported")

        if handle.read(1) != b"\n" and not handle.read(0):
            pass

        rgb = handle.read(PIXELS * 3)
        if len(rgb) != PIXELS * 3:
            raise ValueError(f"{path}: truncated pixel data")
        return rgb


def main() -> int:
    if len(sys.argv) != 3:
        print(
            "Usage: prepare_test_image.py <input> <output.ppm>\n"
            "  input: .data/.raw interleaved RGB, or PNG/JPEG resized to 64x48",
            file=sys.stderr,
        )
        return 1

    source = Path(sys.argv[1])
    output = Path(sys.argv[2])

    if not source.is_file():
        print(f"error: input file not found: {source}", file=sys.stderr)
        return 1

    try:
        rgb = load_source(source)
        write_ppm(output, rgb)
    except (OSError, RuntimeError, ValueError, subprocess.CalledProcessError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1

    print(f"Wrote {output} ({IMAGE_COLS}x{IMAGE_ROWS}) from {source}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
