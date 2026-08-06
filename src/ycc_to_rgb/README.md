# YCC → RGB metrics

Simple guide for running benchmarks and reading the CSV results.

## Quick start (on the ARM VM)

```bash
cd src/ycc_to_rgb

# Once: install Valgrind (needed for Cachegrind)
sudo apt-get update && sudo apt-get install -y valgrind

# Once: make sure the test image exists
make prepare-test-image

# Full baseline: wall-time + instruction/cache metrics
make measure LABEL=baseline
```

Results go in:

- `metrics/walltime.csv` — secondary (how long it took)
- `metrics/cachegrind.csv` — **primary** (instructions + cache misses)

---

## Make commands

| Command | What it does |
|---------|----------------|
| `make test` | Build, run conversion, write PPM + wall-time row |
| `make bench LABEL=...` | Wall-time only (no Valgrind) |
| `make cachegrind LABEL=...` | Cachegrind only (Ir + cache misses) |
| `make measure LABEL=...` | **Both:** wall-time first, then Cachegrind |
| `make prepare-test-image` | Create `testimages/input.ppm` |

Useful options:

```bash
make measure LABEL=baseline          # tag this run
make measure LABEL=opt1 ITERS=2000   # more wall-time iterations
```

Always use a clear `LABEL` so you can compare rows later (`baseline`, `fixedpoint`, etc.).

---

## What “full metrics” means

`make measure` runs **twice on purpose**:

1. **Native run** — accurate wall-clock time (not under Valgrind)  
2. **Cachegrind run** — instruction count + cache misses (slow; that’s normal)

Do **not** trust wall-time printed during the Cachegrind step.

---

## `metrics/walltime.csv` (secondary)

How fast the conversion ran on the real CPU.

| Column | Meaning |
|--------|---------|
| `timestamp` | When the run finished |
| `label` | Your tag (`LABEL=...`) |
| `input` | Image path used |
| `rows`, `cols` | Image size |
| `rgb_to_ycc_routine` | Which RGB→YCC path (`1`=float, `2`=fixed-point) |
| `ycc_to_rgb_routine` | Which YCC→RGB path (`1`=float, `2`=fixed-point) |
| `downsample_mode` | Chroma downsample mode from `CSC_global.h` |
| `upsample_mode` | Chroma upsample mode from `CSC_global.h` |
| `iterations` | Timed loops after 1 warmup |
| `rgb_to_ycc_ms_mean` | Average time for RGB→YCC (milliseconds) |
| `ycc_to_rgb_ms_mean` | Average time for **YCC→RGB** (ms) |
| `ycc_to_rgb_ms_min` | Fastest single YCC→RGB iteration (ms) |
| `total_ms_mean` | RGB→YCC + YCC→RGB average |
| `mpix_per_s` | YCC→RGB throughput in megapixels/second (**higher is better**) |
| `ns_per_pixel` | Nanoseconds per pixel for YCC→RGB (**lower is better**) |
| `diff_max` | Worst single-channel error vs original image |
| `mean_abs_delta` | Average absolute channel error vs original |

**For optimization comparisons, look at:** `ycc_to_rgb_ms_mean` and `ns_per_pixel`.  
**For quality, look at:** `diff_max` and `mean_abs_delta` (shouldn’t get much worse).

---

## `metrics/cachegrind.csv` (primary)

Simulated instruction and cache behavior from Valgrind Cachegrind.

| Column | Meaning |
|--------|---------|
| `timestamp` | When the parse finished |
| `label` | Your tag (`LABEL=...`) |
| `cachegrind_file` | Raw `.out` file for this run |
| `Ir` | **Instruction reads** ≈ total dynamic instructions (**lower is better**) |
| `I1mr` | L1 instruction-cache misses |
| `Dr` | Data reads |
| `Dw` | Data writes |
| `D1mr` | L1 data **read** misses |
| `D1mw` | L1 data **write** misses |
| `DLmr` | Last-level cache **read** misses |
| `DLmw` | Last-level cache **write** misses |
| `D1_misses` | `D1mr + D1mw` — total L1 data misses (**lower is better**) |
| `LL_misses` | `DLmr + DLmw` — total last-level misses (**lower is better**) |
| `Ir_CSC_YCC_to_RGB` | Instructions attributed to `CSC_YCC_to_RGB` |
| `Ir_chrominance_array_upsample` | Instructions in chroma upsampling |
| `Ir_CSC_RGB_to_YCC` | Instructions attributed to `CSC_RGB_to_YCC` |

**For optimization comparisons, look at:**

1. `Ir` (overall work)  
2. `D1_misses` / `LL_misses` (cache behavior)  
3. `Ir_CSC_YCC_to_RGB` and `Ir_chrominance_array_upsample` (where time goes)

More detail for one run:

```bash
less metrics/cachegrind/baseline-*.annotate.txt
# or
make cachegrind-annotate
```

---

## Comparing two optimizations

```bash
make measure LABEL=baseline
# ... change code ...
make measure LABEL=my_opt
```

Then open both CSVs and compare rows with the same ideas:

| Goal | Prefer |
|------|--------|
| Fewer instructions | Lower `Ir` |
| Fewer cache misses | Lower `D1_misses`, `LL_misses` |
| Faster wall time | Lower `ycc_to_rgb_ms_mean` / `ns_per_pixel` |
| Same image quality | Similar `mean_abs_delta` / `diff_max` |

---

## Notes

- Run Cachegrind on the **Linux ARM VM** (Valgrind is usually not on Apple Silicon Macs).  
- Wall-time (`make bench` / step 1 of `make measure`) works on Mac and the VM.  
- Each run **appends** a new CSV row; it does not overwrite old results.  
- Config flags come from `CSC_global.h` (`YCC_to_RGB_ROUTINE`, chroma modes, etc.).
