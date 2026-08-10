# Full RGB ↔ YCC optimized conversion

Combines partner RGB→YCC optimizations with YCC→RGB fixes/opts, plus the
PPM harness and Cachegrind/wall-time profiling suite.

## Quick start (on the ARM VM)

```bash
cd src/full_conversion

# Once: install Valgrind (needed for Cachegrind)
sudo apt-get update && sudo apt-get install -y valgrind

# Once: make sure the test image exists (64x48 default)
make prepare-test-image

# Full baseline: wall-time + instruction/cache metrics
make measure LABEL=baseline

# Or run the full multi-config suite (small + large, several routines)
./run_full_suite.sh
```

Results go in:

- `metrics/walltime.csv` — secondary (how long it took)
- `metrics/cachegrind.csv` — **primary** (instructions + cache misses)

## Image size

| Build | Size | Input PPM |
|-------|------|-----------|
| default | 64×48 | `testimages/input.ppm` |
| `LARGE=1` | 640×480 | `testimages/input_640x480.ppm` |

```bash
make clean
make prepare-test-image LARGE=1
make measure LARGE=1 LABEL=large_baseline ITERS=50
```

Always rebuild when switching `LARGE` or routine overrides (`RGB_ROUTINE` /
`YCC_ROUTINE`), because those are compile-time. `./run_full_suite.sh` does
`make clean-bin` between cases so metrics are kept while binaries are reset.

## Full suite (`run_full_suite.sh`)

On the ARM VM (needs Valgrind for Cachegrind):

```bash
cd src/full_conversion
chmod +x run_full_suite.sh   # once
./run_full_suite.sh
```

Runs wall-time + Cachegrind for both image sizes with downsample/upsample **2**:

| Label | RGB routine | YCC routine | Size |
|-------|-------------|-------------|------|
| `baseline` / `baseline_large` | 2 (int) | 2 (int) | 64×48 / 640×480 |
| `lut_no_neon` / `*_large` | 5 (LUT) | 2 (int) | both |
| `neon` / `*_large` | 6 (neon_v2) | 4 (neon_v3) | both |
| `neon_tiled` / `*_large` | 4 (tiled NEON) | 4 (neon_v3) | both |
| `neon_fused` / `*_large` | 6 (neon_v2) | 5 (NEON fused upsample) | both |

Optional env:

```bash
ITERS_SMALL=500 ITERS_LARGE=20 ./run_full_suite.sh
SKIP_CACHEGRIND=1 ./run_full_suite.sh   # wall-time only
```

## Make commands

| Command | What it does |
|---------|----------------|
| `make test` | Build, run conversion, write PPM + wall-time row |
| `make bench LABEL=...` | Wall-time only (no Valgrind) |
| `make cachegrind LABEL=...` | Cachegrind only (Ir + cache misses) |
| `make measure LABEL=...` | **Both:** wall-time first, then Cachegrind |
| `make prepare-test-image` | Create the sized test PPM from `.data` |

## Source ownership

| File | Origin |
|------|--------|
| `CSC_RGB_to_YCC.c` | `rgb_to_ycc` (float/int/NEON/tiled/LUT) |
| `CSC_YCC_to_RGB.c` | `ycc_to_rgb` (upsample-once, ×256 D coeffs, NEON) |
| `CSC_global.h` | merged (your defaults + partner `TILE_SIZE` / large image / RGB routines) |
| harness / Makefile / scripts | `ycc_to_rgb` profiling suite |

Defaults in `CSC_global.h`: `RGB_to_YCC_ROUTINE=2`, `YCC_to_RGB_ROUTINE=2`,
downsample/upsample mode `2`, D coefficients scaled by \(2^K\).

## What “full metrics” means

`make measure` runs **twice on purpose**:

1. **Native run** — accurate wall-clock time (not under Valgrind)
2. **Cachegrind run** — instruction count + cache misses (slow; that’s normal)

Do **not** trust wall-time printed during the Cachegrind step.

## Comparing two optimizations

```bash
make measure LABEL=baseline
# ... change code / routine defines ...
make measure LABEL=my_opt
```

| Goal | Prefer |
|------|--------|
| Fewer instructions | Lower `Ir` |
| Fewer cache misses | Lower `D1_misses`, `LL_misses` |
| Faster wall time | Lower `*_ms_mean` / `ns_per_pixel` |
| Same image quality | Similar `mean_abs_delta` / `diff_max` |

## Notes

- Run Cachegrind on the **Linux ARM VM** (Valgrind is usually not on Apple Silicon Macs).
- Wall-time (`make bench` / step 1 of `make measure`) works on Mac and the VM.
- Each run **appends** a new CSV row; it does not overwrite old results.
- NEON routines need ARM; float/int/LUT still build on the host for harness smoke tests.
