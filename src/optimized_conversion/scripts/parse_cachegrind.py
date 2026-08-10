#!/usr/bin/env python3
"""Parse a Cachegrind output file into console + CSV metrics.

Primary fields for SENG440 CSC:
  Ir   - instruction reads  (~dynamic instruction count)
  D1mr - L1 data read misses
  D1mw - L1 data write misses
  DLmr - last-level data read misses
  DLmw - last-level data write misses
"""

from __future__ import annotations

import argparse
import csv
import re
import sys
from datetime import datetime
from pathlib import Path


EVENT_NAMES = [
    "Ir",
    "I1mr",
    "ILmr",
    "Dr",
    "D1mr",
    "DLmr",
    "Dw",
    "D1mw",
    "DLmw",
]

# Functions we care about most for this project.
FOCUS_FUNCS = (
    "CSC_YCC_to_RGB",
    "CSC_YCC_to_RGB_brute_force_int",
    "CSC_YCC_to_RGB_brute_force_float",
    "CSC_YCC_to_RGB_neon_v2",
    "CSC_YCC_to_RGB_neon_v3",
    "CSC_YCC_to_RGB_neon_fused",
    "chrominance_array_upsample",
    "chrominance_upsample",
    "CSC_RGB_to_YCC",
    "CSC_RGB_to_YCC_brute_force_int",
    "CSC_RGB_to_YCC_brute_force_float",
    "CSC_RGB_to_YCC_neon",
    "CSC_RGB_to_YCC_neon_tiled",
    "CSC_RGB_to_YCC_neon_v2",
    "CSC_RGB_to_YCC_lut",
    "chrominance_downsample",
)


def parse_cachegrind(path: Path) -> tuple[list[str], list[int], dict[str, list[int]], str]:
    events = list(EVENT_NAMES)
    summary: list[int] | None = None
    per_fn: dict[str, list[int]] = {}
    cmd = ""
    current_fn: str | None = None

    for raw in path.read_text(errors="replace").splitlines():
        line = raw.strip()
        if line.startswith("cmd:"):
            cmd = line[4:].strip()
        elif line.startswith("events:"):
            events = line.split(":", 1)[1].split()
        elif line.startswith("summary:"):
            summary = [int(x) for x in line.split(":", 1)[1].split()]
        elif line.startswith("fn="):
            current_fn = line[3:].strip()
            # Strip leading punctuation some toolchains add (e.g. .CSC_...)
            current_fn = current_fn.lstrip("._")
            if current_fn not in per_fn:
                per_fn[current_fn] = [0] * len(events)
        elif current_fn and line and line[0].isdigit():
            parts = line.split()
            # Format: <line> <count0> <count1> ...
            if len(parts) >= 2:
                counts = [int(x) for x in parts[1 : 1 + len(events)]]
                while len(counts) < len(events):
                    counts.append(0)
                for i, value in enumerate(counts):
                    per_fn[current_fn][i] += value

    if summary is None:
        raise ValueError(f"{path}: missing summary: line")

    while len(summary) < len(events):
        summary.append(0)

    return events, summary, per_fn, cmd


def event_map(events: list[str], values: list[int]) -> dict[str, int]:
    return {name: values[i] if i < len(values) else 0 for i, name in enumerate(events)}


def miss_rate(misses: int, refs: int) -> float:
    if refs <= 0:
        return 0.0
    return 100.0 * misses / refs


def print_report(
    label: str,
    path: Path,
    events: list[str],
    summary: list[int],
    per_fn: dict[str, list[int]],
    cmd: str,
) -> None:
    total = event_map(events, summary)
    ir = total.get("Ir", 0)
    dr = total.get("Dr", 0)
    dw = total.get("Dw", 0)
    d1mr = total.get("D1mr", 0)
    d1mw = total.get("D1mw", 0)
    dlmr = total.get("DLmr", 0)
    dlmw = total.get("DLmw", 0)
    i1mr = total.get("I1mr", 0)

    print("=== Cachegrind Metrics ===")
    print(f"Label:     {label}")
    print(f"File:      {path}")
    if cmd:
        print(f"Command:   {cmd}")
    print()
    print("Program totals (simulated):")
    print(f"  Ir   (instructions):     {ir:,}")
    print(f"  I1mr (I1 misses):        {i1mr:,}  ({miss_rate(i1mr, ir):.4f}%)")
    print(f"  Dr   (data reads):       {dr:,}")
    print(f"  Dw   (data writes):      {dw:,}")
    print(f"  D1mr (D1 read misses):   {d1mr:,}  ({miss_rate(d1mr, dr):.4f}%)")
    print(f"  D1mw (D1 write misses):  {d1mw:,}  ({miss_rate(d1mw, dw):.4f}%)")
    print(f"  DLmr (LL read misses):   {dlmr:,}  ({miss_rate(dlmr, dr):.4f}%)")
    print(f"  DLmw (LL write misses):  {dlmw:,}  ({miss_rate(dlmw, dw):.4f}%)")
    print(f"  D1 total misses:         {d1mr + d1mw:,}")
    print(f"  LL total misses:         {dlmr + dlmw:,}")
    print()
    print("Hot CSC functions (by Ir):")

    ranked = []
    for name, values in per_fn.items():
        em = event_map(events, values)
        if any(key in name for key in FOCUS_FUNCS) or em.get("Ir", 0) > 0:
            if any(key in name for key in FOCUS_FUNCS):
                ranked.append((em.get("Ir", 0), name, em))
    ranked.sort(reverse=True)

    if not ranked:
        # Fall back: top functions containing CSC_ / chrominance
        for name, values in per_fn.items():
            if re.search(r"CSC_|chrominance", name):
                em = event_map(events, values)
                ranked.append((em.get("Ir", 0), name, em))
        ranked.sort(reverse=True)

    for ir_count, name, em in ranked[:12]:
        print(
            f"  {name}: Ir={ir_count:,}  "
            f"D1miss={em.get('D1mr', 0) + em.get('D1mw', 0):,}  "
            f"LLmiss={em.get('DLmr', 0) + em.get('DLmw', 0):,}"
        )


def append_csv(
    csv_path: Path,
    label: str,
    out_file: Path,
    events: list[str],
    summary: list[int],
    per_fn: dict[str, list[int]],
) -> None:
    total = event_map(events, summary)

    def fn_ir(substr: str) -> int:
        best = 0
        for name, values in per_fn.items():
            if substr in name:
                best = max(best, event_map(events, values).get("Ir", 0))
        return best

    row = {
        "timestamp": datetime.now().strftime("%Y-%m-%dT%H:%M:%S"),
        "label": label,
        "cachegrind_file": str(out_file),
        "Ir": total.get("Ir", 0),
        "I1mr": total.get("I1mr", 0),
        "Dr": total.get("Dr", 0),
        "Dw": total.get("Dw", 0),
        "D1mr": total.get("D1mr", 0),
        "D1mw": total.get("D1mw", 0),
        "DLmr": total.get("DLmr", 0),
        "DLmw": total.get("DLmw", 0),
        "D1_misses": total.get("D1mr", 0) + total.get("D1mw", 0),
        "LL_misses": total.get("DLmr", 0) + total.get("DLmw", 0),
        "Ir_CSC_YCC_to_RGB": fn_ir("CSC_YCC_to_RGB"),
        "Ir_chrominance_array_upsample": fn_ir("chrominance_array_upsample"),
        "Ir_CSC_RGB_to_YCC": fn_ir("CSC_RGB_to_YCC"),
    }

    csv_path.parent.mkdir(parents=True, exist_ok=True)
    write_header = not csv_path.exists() or csv_path.stat().st_size == 0
    with csv_path.open("a", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(row.keys()))
        if write_header:
            writer.writeheader()
        writer.writerow(row)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("cachegrind_out", type=Path, help="cachegrind.out.* file")
    parser.add_argument("--label", default="baseline")
    parser.add_argument(
        "--csv",
        type=Path,
        default=Path("metrics/cachegrind.csv"),
        help="CSV file to append",
    )
    args = parser.parse_args()

    if not args.cachegrind_out.is_file():
        print(f"error: file not found: {args.cachegrind_out}", file=sys.stderr)
        return 1

    try:
        events, summary, per_fn, cmd = parse_cachegrind(args.cachegrind_out)
    except ValueError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1

    print_report(args.label, args.cachegrind_out, events, summary, per_fn, cmd)
    append_csv(args.csv, args.label, args.cachegrind_out, events, summary, per_fn)
    print(f"\nMetrics appended to {args.csv}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
