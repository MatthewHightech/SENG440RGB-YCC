# Full RGB ↔ YCC conversion (merged)

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

Always `make clean` when switching `LARGE`, because array sizes are compile-time.

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
