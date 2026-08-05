# YCC→RGB tooling: Cachegrind + wall-time metrics

This folder has helpers for running the CSC test harness and collecting:

1. **Primary:** instruction count (**Ir**) and **cache misses** via Cachegrind  
2. **Secondary:** wall-clock time via `clock_gettime(CLOCK_MONOTONIC)`  

Run everything from `src/ycc_to_rgb/` (parent of this `scripts/` directory),
usually via the Makefile.

## Scripts

| Script | Purpose |
|--------|---------|
| `prepare_test_image.py` | Build a 64×48 PPM from course `.data` / `.raw` or a PNG/JPEG |
| `run_cachegrind.sh` | Run Cachegrind, annotate, parse Ir/misses to CSV |
| `parse_cachegrind.py` | Parse a `cachegrind.out.*` file → console report + CSV row |

Wall-time recording lives in `CSC_main.c` (not a separate script).

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
own runs with the same Valgrind/Cachegrind version and build flags.

**Never use wall-time collected under Valgrind.** Cachegrind/Memcheck distort
timing. Always measure wall-time in a separate native run (`make bench` or
step 1 of `make measure`).

---

## Secondary metrics (wall-time)

Collected with `CLOCK_MONOTONIC` around `CSC_RGB_to_YCC` / `CSC_YCC_to_RGB`:

| Field | Meaning |
|-------|---------|
| `ycc_to_rgb_ms_mean` / `ycc_to_rgb_ms_min` | Inverse CSC time |
| `rgb_to_ycc_ms_mean` | Forward CSC time (context) |
| `ns_per_pixel` / `mpix_per_s` | Size-independent throughput |
| `diff_max` / `mean_abs_delta` | Quality vs input |

Default: **1 warmup + 1000 timed iterations** (override with `ITERS=`).

CSV path: `metrics/walltime.csv`

---

## Important: Cachegrind on the Linux ARM VM

Valgrind is typically **not available on Apple Silicon macOS**. Install and
run Cachegrind on your **Linux ARM VM**. Wall-time `make bench` works on both
Mac and the VM.

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

# 2. Recommended: wall-time THEN Cachegrind (same LABEL)
make measure LABEL=baseline

# Or separately:
make bench LABEL=baseline          # wall-time only
make cachegrind LABEL=baseline     # Ir / misses only (needs Valgrind)
```

`make measure` does:

1. **Native** timed run → `metrics/walltime.csv`  
2. **Cachegrind** run with `--iters 1` → `metrics/cachegrind.csv`  

Outputs land under `metrics/` (gitignored).

---

## How to compare optimizations

Tag every run with a clear `LABEL`:

```bash
make measure LABEL=baseline

# ... implement an optimization ...
make measure LABEL=no-redundant-upsample

# ... another change ...
make measure LABEL=fixedpoint
```

### Primary — `metrics/cachegrind.csv`

| Column | What to look for |
|--------|------------------|
| **Ir** | Lower = fewer instructions |
| **D1_misses** | Lower = better L1 data-cache behavior |
| **LL_misses** | Lower = better last-level cache behavior |
| **Ir_CSC_YCC_to_RGB** | Instructions in the inverse CSC entry |
| **Ir_chrominance_array_upsample** | Often dominates before fixing redundant upsampling |

### Secondary — `metrics/walltime.csv`

| Column | What to look for |
|--------|------------------|
| **ycc_to_rgb_ms_mean** | Lower = faster inverse CSC |
| **ns_per_pixel** | Size-independent; good for reports |
| **mean_abs_delta** | Should not get much worse |

Hot-spot view:

```bash
make cachegrind-annotate
# or:
less metrics/cachegrind/baseline-*.annotate.txt
```

Focus on `CSC_YCC_to_RGB` and `chrominance_array_upsample`.

---

## Manual commands

### Wall-time only

```bash
make native
./csc_ycc_to_rgb testimages/input.ppm testimages/output.ppm \
  --label baseline --iters 1000 --metrics metrics/walltime.csv
```

### Cachegrind only

```bash
make native-profile
valgrind --tool=cachegrind \
  --cache-sim=yes \
  --branch-sim=no \
  --cachegrind-out-file=metrics/cachegrind/run.out \
  ./csc_ycc_to_rgb testimages/input.ppm testimages/output.ppm \
  --iters 1 --label baseline --metrics /dev/null

cg_annotate --auto=yes metrics/cachegrind/run.out | less

python3 scripts/parse_cachegrind.py metrics/cachegrind/run.out \
  --label baseline \
  --csv metrics/cachegrind.csv
```

Or:

```bash
LABEL=baseline ITERS=1 bash scripts/run_cachegrind.sh
```

---

## Rules for fair comparisons

1. **Same input image** for A/B comparisons of one optimization.  
2. **Same `CSC_global.h` modes** when that isn’t the variable under test.  
3. **Same build flags** — Makefile uses `-O2 -Wall -g`.  
4. Always set a meaningful **`LABEL`** (shared by wall-time and Cachegrind).  
5. Treat Cachegrind **Ir / misses as primary**; wall-time as **secondary**.  
6. Under Cachegrind use **`--iters 1`** (Makefile/`run_cachegrind.sh` already do).  
7. Cachegrind is **slow** — that is normal.

---

## Makefile targets

| Target | What it does |
|--------|----------------|
| `make` / `make native` | Build host binary with `-O2 -g` |
| `make native-profile` | Alias for symbol-friendly profile build |
| `make test` | Round-trip + wall-time metrics |
| `make bench LABEL=...` | **Wall-time only** (no Valgrind) |
| `make measure LABEL=...` | **Wall-time then Cachegrind** (full report run) |
| `make cachegrind LABEL=...` | Cachegrind only → annotate → CSV |
| `make cachegrind-annotate` | `cg_annotate` the latest `.out` |
| `make prepare-test-image` | Create `testimages/input.ppm` |
| `make arm` / `make deploy` | Cross-compile / scp to VM |
| `make clean` | Remove binaries and Cachegrind outs |

Variables:

- `LABEL` — run tag (default `baseline`)  
- `ITERS` — wall-time iterations (default `1000`; Cachegrind forced to `1`)  

---

## Visual correctness (PPM)

```bash
make test
open testimages/output.ppm   # macOS; on Linux use eog/gimp/etc.
```

Some channel error is expected with chroma subsampling; large quality
regressions after an optimization are a red flag.

---

## Suggested workflow for the report

1. On the VM: install Valgrind, pull/build the project.  
2. `make measure LABEL=baseline` — wall-time + Ir/misses.  
3. Apply one optimization at a time.  
4. Re-run `make measure LABEL=...`.  
5. Quote **Ir** and **miss** deltas primarily; mention wall-time as secondary.  
6. Keep `metrics/walltime.csv` and `metrics/cachegrind.csv` aligned by `label`.
