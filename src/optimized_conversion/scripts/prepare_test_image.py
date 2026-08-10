#!/usr/bin/env python3
"""Build a PPM test image from course .data/.raw or a PNG/JPEG.

Default size is 64x48. Override with IMAGE_ROWS / IMAGE_COLS env vars
(e.g. Makefile LARGE=1 sets 640x480), or pass --rows/--cols.
"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path


def write_ppm(path: Path, rgb: bytes, rows: int, cols: int) -> None:
    expected = rows * cols * 3
    if len(rgb) != expected:
        raise ValueError(f"expected {expected} bytes of RGB data, got {len(rgb)}")
    path.parent.mkdir(parents=True, exist_ok=True)
    header = f"P6\n{cols} {rows}\n255\n".encode("ascii")
    path.write_bytes(header + rgb)


def infer_size_from_raw(data: bytes) -> tuple[int, int] | None:
    known = {
        64 * 48 * 3: (64, 48),
        640 * 480 * 3: (640, 480),
    }
    return known.get(len(data))


def read_interleaved_rgb(path: Path, rows: int, cols: int) -> bytes:
    data = path.read_bytes()
    expected = rows * cols * 3
    if len(data) == expected:
        return data
    inferred = infer_size_from_raw(data)
    if inferred is not None:
        raise ValueError(
            f"{path}: file is {inferred[1]}x{inferred[0]} "
            f"({len(data)} bytes), but requested {cols}x{rows}"
        )
    raise ValueError(f"{path}: expected {expected} bytes, found {len(data)}")


def resize_with_pillow(path: Path, rows: int, cols: int) -> bytes:
    try:
        from PIL import Image
    except ImportError as exc:
        raise RuntimeError(
            "install Pillow (`pip install pillow`) or use ffmpeg to resize images"
        ) from exc

    with Image.open(path) as image:
        resized = image.convert("RGB").resize(
            (cols, rows), Image.Resampling.LANCZOS
        )
        return resized.tobytes()


def resize_with_ffmpeg(path: Path, rows: int, cols: int) -> bytes:
    pixels = rows * cols
    command = [
        "ffmpeg",
        "-y",
        "-i",
        str(path),
        "-vf",
        f"scale={cols}:{rows}",
        "-pix_fmt",
        "rgb24",
        "-f",
        "rawvideo",
        "pipe:1",
    ]
    result = subprocess.run(
        command, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    if len(result.stdout) != pixels * 3:
        raise RuntimeError(
            f"ffmpeg produced {len(result.stdout)} bytes, expected {pixels * 3}"
        )
    return result.stdout


def read_interleaved_rgb_from_ppm(path: Path, rows: int, cols: int) -> bytes:
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
        if width != cols or height != rows:
            raise ValueError(
                f"{path}: expected {cols}x{rows}, got {width}x{height}"
            )
        if maxval != 255:
            raise ValueError(f"{path}: only 8-bit PPM is supported")

        handle.read(1)  # single whitespace after maxval
        rgb = handle.read(rows * cols * 3)
        if len(rgb) != rows * cols * 3:
            raise ValueError(f"{path}: truncated pixel data")
        return rgb


def load_source(path: Path, rows: int, cols: int) -> bytes:
    suffix = path.suffix.lower()
    if suffix in {".data", ".raw"}:
        return read_interleaved_rgb(path, rows, cols)
    if suffix == ".ppm":
        return read_interleaved_rgb_from_ppm(path, rows, cols)
    if suffix in {".png", ".jpg", ".jpeg", ".bmp", ".gif", ".webp"}:
        try:
            return resize_with_pillow(path, rows, cols)
        except RuntimeError:
            return resize_with_ffmpeg(path, rows, cols)
    raise RuntimeError(
        f"unsupported input format: {path.suffix} "
        "(use .data, .raw, .ppm, .png, or .jpg)"
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument(
        "--rows",
        type=int,
        default=int(os.environ.get("IMAGE_ROWS", "64")),
    )
    parser.add_argument(
        "--cols",
        type=int,
        default=int(os.environ.get("IMAGE_COLS", "48")),
    )
    args = parser.parse_args()

    if not args.input.is_file():
        print(f"error: input file not found: {args.input}", file=sys.stderr)
        return 1

    try:
        rgb = load_source(args.input, args.rows, args.cols)
        write_ppm(args.output, rgb, args.rows, args.cols)
    except (OSError, RuntimeError, ValueError, subprocess.CalledProcessError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1

    print(f"Wrote {args.output} ({args.cols}x{args.rows}) from {args.input}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
