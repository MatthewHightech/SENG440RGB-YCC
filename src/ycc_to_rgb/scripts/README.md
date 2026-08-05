# YCC→RGB tooling: Cachegrind metrics

This folder has helpers for running the CSC test harness and collecting
**instruction count** and **cache miss** metrics with Valgrind Cachegrind —
the primary performance metrics for this SENG 440 project.

## Scripts

| Script | Purpose |
|--------|---------|
| `prepare_test_image.py` | Build a 64×48 PPM from course `.data` / `.raw` or a PNG/JPEG |
| `run_cachegrind.sh` | Build-time wrapper: run Cachegrind, annotate, parse to CSV |
| `parse_cachegrind.py` | Parse a `cachegrind.out.*` file → console report + CSV row |

Run everything from `src/ycc_to_rgb/` (parent of this `scripts/` directory),
usually via the Makefile.

---

## Primary metrics (Cachegrind)

| Event | Meaning |
|-------|---------|
| **Ir** | Instruction reads ≈ **dynamic instruction count** |
| **D1mr / D1mw** | L1 data cache **read/write misses** |
| **DLmr / DLmw** | Last-level (LL) data cache misses |
| **I1mr** | Instruction-cache misses (usually secondary) |

Derived CSV fields also include:

- `D1_misses` = D1mr + D1mw  
- `LL_misses` = DLmr + DLmw  
- `Ir_CSC_YCC_to_RGB`, `Ir_chrominance_array_upsample`, `Ir_CSC_RGB_to_YCC`

These counts are **simulated** by Cachegrind. They are comparable across your
own runs with the same Valgrind/Cachegrind version and build flags. They are
**not** identical to real ARM silicon cycle counts, but they are the right
tool for “instruction count + cache misses” in this course.

**Do not use Valgrind Memcheck for timing.** Memcheck slows the program
~10–50× and distorts wall-clock measurements. Use Cachegrind for Ir/misses;
optional wall-clock timing is a separate, secondary metric.

---

## Important: run on the Linux ARM VM

Valgrind is typically **not available on Apple Silicon macOS**. Install and
run Cachegrind on your **Linux ARM VM**.

```bash
# On the VM
sudo apt-get update
sudo apt-get install -y valgrind
```

Confirm:

```bash
valgrind --version
cg_annotate --version
```

---

## Quick start

From `src/ycc_to_rgb/`:

```bash
# 1. Prepare a viewable test image (once)
make prepare-test-image

# Optional: from your own photo
make prepare-test-image IMG=/path/to/photo.png

# 2. Baseline Cachegrind run
make cachegrind LABEL=baseline
```

That will:

1. Build with `-O2 -g` (symbols so `cg_annotate` can name functions)
2. Run under `--tool=cachegrind`
3. Write `metrics/cachegrind/<label>-<timestamp>.out`
4. Write an annotated report `*.annotate.txt`
5. Append totals to `metrics/cachegrind.csv`

Outputs land under `metrics/` (gitignored).

---

## How to compare optimizations

Tag every run with a clear `LABEL` so CSV rows stay identifiable:

```bash
make cachegrind LABEL=baseline

# ... implement an optimization ...
make cachegrind LABEL=no-redundant-upsample

# ... another change ...
make cachegrind LABEL=fixedpoint
```

Then open `metrics/cachegrind.csv` and compare:

| Column | What to look for |
|--------|------------------|
| **Ir** | Lower = fewer instructions |
| **D1_misses** | Lower = better L1 data-cache behavior |
| **LL_misses** | Lower = better last-level cache behavior |
| **Ir_CSC_YCC_to_RGB** | Instructions attributed to the inverse CSC entry |
| **Ir_chrominance_array_upsample** | Often dominates before fixing redundant upsampling |

For a detailed hot-spot view:

```bash
make cachegrind-annotate
# or:
less metrics/cachegrind/baseline-*.annotate.txt
```

Focus on:

- `CSC_YCC_to_RGB`
- `CSC_YCC_to_RGB_brute_force_int` / `_float`
- `chrominance_array_upsample`

With the starter bug (full-image upsample inside every 2×2 block),
`chrominance_array_upsample` should dominate **Ir**.

---

## Manual commands (without Make)

```bash
cd src/ycc_to_rgb
make native-profile
make prepare-test-image

valgrind --tool=cachegrind \
  --cache-sim=yes \
  --branch-sim=no \
  --cachegrind-out-file=metrics/cachegrind/run.out \
  ./csc_ycc_to_rgb testimages/input.ppm testimages/output.ppm

cg_annotate --auto=yes metrics/cachegrind/run.out | less

python3 scripts/parse_cachegrind.py metrics/cachegrind/run.out \
  --label baseline \
  --csv metrics/cachegrind.csv
```

Or use the wrapper directly:

```bash
LABEL=baseline BINARY=./csc_ycc_to_rgb \
  INPUT=testimages/input.ppm OUTPUT=testimages/output.ppm \
  bash scripts/run_cachegrind.sh
```

---

## Rules for fair comparisons

1. **Same input image** for A/B comparisons of one optimization.
2. **Same `CSC_global.h` modes** when that isn’t the variable under test
   (`YCC_to_RGB_ROUTINE`, chroma up/downsample modes).
3. **Same build flags** — Makefile uses `-O2 -Wall -g`.
4. Always set a meaningful **`LABEL`**.
5. Treat Cachegrind **Ir / misses as primary**; don’t mix them with wall-clock
   ms as if they were the same metric.
6. Cachegrind is **slow** — that is normal. You are measuring counts, not
   interactive runtime.

---

## Makefile targets (parent directory)

| Target | What it does |
|--------|----------------|
| `make` / `make native` | Build host binary with `-O2 -g` |
| `make native-profile` | Alias for a symbol-friendly profile build |
| `make test` | Round-trip PPM smoke test |
| `make prepare-test-image` | Create `testimages/input.ppm` |
| `make cachegrind LABEL=...` | Full Cachegrind → annotate → CSV |
| `make cachegrind-annotate` | `cg_annotate` the latest `.out` in a pager |
| `make arm` | Cross-compile `csc_ycc_to_rgb_aarch64` |
| `make deploy` | `scp` ARM binary to the VM |
| `make clean` | Remove binaries and Cachegrind outs |

---

## Visual correctness (PPM)

Before trusting a faster Ir number, check that the image still looks right:

```bash
make test
open testimages/output.ppm   # macOS Preview; on Linux use eog/gimp/etc.
```

The harness prints max / mean channel delta vs the input. Some error is
expected with chroma subsampling; large regressions after an optimization
are a red flag.

---

## Suggested workflow for the report

1. On the VM: install Valgrind, pull/build the project.
2. `make cachegrind LABEL=baseline` — record Ir and D1/LL misses.
3. Apply one optimization at a time.
4. Re-run with a new `LABEL`; append to the same CSV.
5. Quote **Ir** and **miss** deltas (and optionally annotate excerpts) in the
   progress/final report.
6. Optionally mention wall-clock only as secondary confirmation.
