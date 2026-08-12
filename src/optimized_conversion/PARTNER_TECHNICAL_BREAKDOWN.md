# Partner Technical Breakdown — RGB→YCC Optimizations

**Purpose:** Quick-reference for defending Brendon's side of the SENG 440 project during Q&A.  
**Final code:** `src/optimized_conversion/`  
**Primary files:** `CSC_RGB_to_YCC.c`, `CSC_YCC_to_RGB.c`, `CSC_global.h`

---

## 1. What your partner owned

| Area | Partner's contribution | Where in code |
|------|------------------------|---------------|
| **Fixed-point math** | Q8 coefficient scaling, rounding bias, overflow analysis | `CSC_global.h`, both `.c` files |
| **NEON (RGB→YCC)** | v1 → tiled → **neon_v2** (final forward path) | `CSC_RGB_to_YCC.c` routines 3, 4, 6 |
| **NEON (YCC→RGB)** | Ported v2, discovered overflow, built **neon_v3** | `CSC_YCC_to_RGB.c` routines 3, 4 |
| **LUT** | Precomputed multiply tables for RGB→YCC | `CSC_RGB_to_YCC.c` routine 5 |
| **Tiling** | 16×16 tile traversal wrapper around NEON v1 | `CSC_RGB_to_YCC.c` routine 4 |
| **Assembly analysis** | `-S` disassembly, per-loop vs full-image instruction counts | Report § Optimization and Assembly Analysis |

Your side (Matt) handled the YCC→RGB **upsampling-once fix**, **8-bit D-coefficient correction**, profiling harness, and round-trip verification. This doc focuses on partner content.

---

## 2. The problem in one paragraph

We convert RGB images to YCbCr (YCC) and back on **ARM without relying on floating point**. Each conversion is a **3×3 matrix multiply** per pixel, plus **4:2:0 chroma subsampling** (RGB→YCC averages 2×2 color blocks; YCC→RGB interpolates them back). The baseline does this one 2×2 block at a time with scalar integer MACs. The partner's work asks: *how do we use ARM NEON SIMD to process many pixels per instruction while staying in fixed-point and preserving ~1.85 mean RGB error on round-trip?*

---

## 3. Fixed-point arithmetic (the foundation)

### Why fixed-point?

Target platforms (UVic SBC ARMv7-A, 32-bit QEMU VM) either **lack an FPU** or emulate float slowly. Integer MAC units are fast; coefficients are pre-scaled so all math stays in integers.

### Q8 format (`K = 8`)

```c
#define K 8
#define UNITY (1 << K)   // 256
```

- A float coefficient `c` becomes integer `round(c × 256)`.
- After accumulating products, **`>> K`** recovers the 8-bit pixel value.
- **Why K=8?** RGB channels are 8-bit; K=8 gives enough fractional precision that rounding error is invisible, while keeping intermediate sums small enough to fit in registers. K=16 would push 16-bit accumulators into overflow territory faster.

### RGB→YCC formula (integer form)

```
Y  = ((16  << K) + C11·R + C12·G + C13·B + bias) >> K
Cb = ((128 << K) − C21·R − C22·G + C23·B + bias) >> K
Cr = ((128 << K) + C31·R − C32·G − C33·B + bias) >> K
```

**Coefficients** (`CSC_global.h`):

| Constant | Float equiv | Value |
|----------|-------------|-------|
| C11 | 0.257 | 66 |
| C12 | 0.504 | 129 |
| C13 | 0.098 | 25 |
| C21 | 0.148 | 38 |
| C22 | 0.291 | 74 |
| C23 | 0.439 | 112 |
| C31 | 0.439 | 112 |
| C32 | 0.368 | 94 |
| C33 | 0.071 | 18 |

### YCC→RGB formula (integer form)

```
R = (D1·(Y−16)  + D2·(Cr−128) + bias) >> K
G = (D1·(Y−16) − D3·(Cr−128) − D4·(Cb−128) + bias) >> K
B = (D1·(Y−16)  + D5·(Cb−128) + bias) >> K
```

**Coefficients:**

| Constant | Float equiv | Value |
|----------|-------------|-------|
| D1 | 1.164 | 298 |
| D2 | 1.596 | 409 |
| D3 | 0.813 | 208 |
| D4 | 0.392 | 100 |
| D5 | 2.017 | 517 |

*(Report rounds D5 to 516; code uses 517 = round(2.017 × 256).)*

### Rounding vs truncation

Every channel adds **`bias = 1 << (K−1)`** (= 128) before the final shift. That is **round-to-nearest** instead of truncate-toward-zero. Without it, repeated rounding always biases dark — visible after round-trip conversion.

### Why accumulators had to widen (critical for NEON story)

For YCC→RGB, worst-case product before shift:

```
D1 × (Y−16) + D2 × (Cr−128) + bias
298 × 110 + 409 × 127 + 128 ≈ 84,663   (well past int16 max 32,767)
```

Even a single term `298 × 110 = 32,780` exceeds **int16_t**. NEON's `vmlaq_n_s16` **wraps silently**; `vqmovun_s16` only saturates *after* the damage is done → mostly black output. **neon_v3** fixes this by widening to **int32x4_t** for the MAC stage.

---

## 4. Routine map (compile-time flags)

### RGB → YCC (`RGB_to_YCC_ROUTINE`)

| # | Function | Description |
|---|----------|-------------|
| 1 | `CSC_RGB_to_YCC_brute_force_float` | Reference float |
| 2 | `CSC_RGB_to_YCC_brute_force_int` | Baseline fixed-point |
| 3 | `CSC_RGB_to_YCC_neon` | **NEON v1** — 4 pixels in `int32x4_t` |
| 4 | `CSC_RGB_to_YCC_neon_tiled` | **Tiling** — 16×16 tiles calling v1 |
| 5 | `CSC_RGB_to_YCC_lut` | **LUT** — table lookups |
| 6 | `CSC_RGB_to_YCC_neon_v2` | **Final NEON** — 8-wide strips |

### YCC → RGB (`YCC_to_RGB_ROUTINE`)

| # | Function | Description |
|---|----------|-------------|
| 1 | float | Reference |
| 2 | int | Baseline fixed-point |
| 3 | `CSC_YCC_to_RGB_neon_v2` | Port of v2 — **broken (int16 overflow)** |
| 4 | `CSC_YCC_to_RGB_neon_v3` | **Final NEON** — int32 MACs |

**Production config:** `RGB_to_YCC_ROUTINE=6` + `YCC_to_RGB_ROUTINE=4` (label `neon` in the test suite).

---

## 5. NEON iterations — the main story

NEON gives **128-bit vector registers**. The partner iterated four times on RGB→YCC and twice on YCC→RGB before landing on the winning design.

### Evolution at a glance

```
Baseline int          → 1 pixel cluster (2×2) per loop iteration, scalar MACs
NEON v1  (routine 3)  → 4 pixels vectorized, but wastes 75% of each lane
NEON tiled (routine 4)→ same v1 kernel, different loop order (16×16 tiles)
LUT      (routine 5)  → replace multiply with memory lookup
NEON v2  (routine 6)  → 8 pixels per load/store; 16-bit MACs ✓ for RGB→YCC
YCC neon_v2 (rout. 3) → direct port of v2 → int16 overflow ✗
YCC neon_v3 (rout. 4) → split 8-wide load into two 4-wide int32 MACs ✓
```

---

### 5.1 NEON v1 — `CSC_RGB_to_YCC_neon` (routine 3)

**What it does:** Packs 4 pixel values (one 2×2 block) into `int32x4_t` and runs `vmlaq_n_s32` / `vmlsq_n_s32` for Y, Cb, Cr.

**Key intrinsics:**
- `vdupq_n_s32` — broadcast bias (16<<K or 128<<K + rounding)
- `vmlaq_n_s32` / `vmlsq_n_s32` — multiply-accumulate by scalar coefficient
- `vshrq_n_s32` — arithmetic shift by K
- `vgetq_lane_s32` — extract each result byte

**Why it underperformed:**
- Each `int32x4_t` lane holds **one 8-bit pixel** in the low bits; upper 24 bits are unused.
- Still processes only **one 2×2 block** per call — loop runs `(rows/2) × (cols/2)` times.
- Scalar gather into the vector (`{R[0][0], R[0][1], R[1][0], R[1][1]}`) adds overhead.

**Takeaway for Q&A:** "We proved SIMD worked, but we weren't feeding the register wide enough."

---

### 5.2 Tiling — `CSC_RGB_to_YCC_neon_tiled` (routine 4)

**What it does:** Reorders traversal into **16×16 tiles** (`TILE_SIZE` in `CSC_global.h`), still calling the v1 kernel on each 2×2 block inside the tile.

```c
for (tile_row = 0; tile_row < IMAGE_ROW_SIZE; tile_row += TILE_SIZE)
  for (tile_col = 0; tile_col < IMAGE_COL_SIZE; tile_col += TILE_SIZE)
    for (row = tile_row; row < tile_row + TILE_SIZE; row += 2)
      for (col = tile_col; col < tile_col + TILE_SIZE; col += 2)
        CSC_RGB_to_YCC_neon(row, col);
```

**Hypothesis:** Processing spatially local blocks improves L1 cache hit rate before data is evicted.

**Why it failed on our benchmarks:**

| Metric | `neon` (v2) | `neon_tiled` (640×480) |
|--------|-------------|------------------------|
| Total wall time | 6.12 ms | 7.00 ms |
| Ir (RGB→YCC) | 8.9M | 19.9M |
| LL cache misses | 273,594 | 273,594 |

- Tile boundary logic adds instructions without changing the inner kernel.
- **LL misses stayed flat** — cache was never the bottleneck at these image sizes.
- Still uses the inefficient v1 4-pixel kernel inside each tile.

**Takeaway:** "Tiling and SIMD width are independent optimizations. Narrow SIMD inside tiles can't fix a under-filled register problem."

---

### 5.3 LUT — `CSC_RGB_to_YCC_lut` (routine 5)

**What it does:** At startup, `lut_init()` fills **9 tables × 256 entries**:

```c
lut_Y_R[i]  =  C11 * i;
lut_Cb_R[i] = -C21 * i;   // negative coeffs pre-negated
// ... etc for all (output, input) pairs
```

Per pixel, conversion becomes **3 table lookups + 2 adds + shift** instead of 3 multiplies:

```c
Y = (bias_Y + lut_Y_R[r] + lut_Y_G[g] + lut_Y_B[b]) >> K;
```

**Why it failed:**

| Metric | baseline | lut_no_neon (640×480) |
|--------|----------|------------------------|
| RGB→YCC Ir | 22.6M | 33.2M |
| L1 misses | 371k | 545k |
| Wall time | 9.25 ms | 9.74 ms |

- Replaces cheap integer `MUL` with **9 memory loads per pixel cluster** (cache traffic).
- On ARM, 8-bit×8-bit multiply in a MAC is already fast; LUT shifts cost to memory bandwidth.
- **Negative result is valuable:** shows profiling beats intuition.

---

### 5.4 NEON v2 — `CSC_RGB_to_YCC_neon_v2` (routine 6) ★ WINNER (RGB→YCC)

**The breakthrough:** Change loop granularity from 2×2 blocks to **8-column strips across 2 rows**.

**Pipeline per strip:**

1. **Load** — `vld1_u8` loads 8 consecutive R/G/B bytes per row (6 vector loads total for 2 rows).
2. **Widen** — `vmovl_u8` promotes `uint8x8_t` → `uint16x8_t` so products fit in 16 bits.
   - Max product: `129 × 255 = 32,895` < 65,535 ✓ safe in uint16.
3. **MAC** — `vmlaq_n_u16` / `vmlsq_n_u16` with C coefficients; bias baked into initial vector.
4. **Narrow + store** — `vshrq_n_u16` then `vmovn_u16` → `vst1_u8` writes 8 Y values at once.
5. **Downsample** — Cb/Cr computed for 8 pixels per row, then `chrominance_downsample` on four 2×2 groups.

**Why it's ~2.5× fewer instructions (640×480):**

| | Integer baseline | neon_v2 |
|--|------------------|---------|
| RGB→YCC Ir | 22,618,342 | 8,924,866 |
| Loop trips per row pair | cols/2 | cols/8 |
| Pixels per inner iteration | 4 | 16 (8 per row × 2 rows) |

**Assembly insight:** A single `-O2` loop body for neon_v2 has **279 instructions** vs **216** for integer — neon_v2 looks *worse* per iteration. But it runs **~16× fewer times** across the image, so total Ir drops 2.53×.

---

### 5.5 YCC→RGB NEON v2 — `CSC_YCC_to_RGB_neon_v2` (routine 3) ✗ BROKEN

**What happened:** Partner copied the RGB→YCC v2 pattern directly:
- `vld1_u8` load Y, Cb_temp, Cr_temp (8 pixels)
- `vmovl_u8` → `int16x8_t`
- Subtract 16 / 128 offsets
- `vmlaq_n_s16` / `vmlsq_n_s16` with D1–D5
- `vqmovun_s16` saturate to uint8

**Symptom:** Output image almost entirely **black**.

**Root cause:** YCC→YCC coefficients (D1=298, D2=409) produce intermediates up to **~123,000**, far above int16 max (32,767). `vmlaq_n_s16` wraps modulo 2¹⁶; saturation runs on garbage.

**Why RGB→YCC v2 was fine but this wasn't:** Forward coeffs (max ~129) × 8-bit input stay in uint16 range. Inverse coeffs (~517) × offset values (up to 127) do not.

---

### 5.6 YCC→RGB NEON v3 — `CSC_YCC_to_RGB_neon_v3` (routine 4) ★ WINNER (YCC→RGB)

**Fix:** Keep the **8-wide load/store** from v2, but run MACs in **32-bit**:

```c
// Shared helper: neon_ycc_to_rgb_strip()
int32x4_t y_lo  = vmovl_s16(vget_low_s16(y_s));   // lanes 0–3
int32x4_t y_hi  = vmovl_s16(vget_high_s16(y_s));  // lanes 4–7
r_lo = vmlaq_n_s32(r_lo, y_lo, D1);
r_lo = vmlaq_n_s32(r_lo, cr_lo, D2);
// ... same for g, b, hi halves
vst1_u8(R_dst, vqmovun_s16(vcombine_s16(vqmovn_s32(r_lo), vqmovn_s32(r_hi))));
```

**Data flow:**

```
uint8×8  ──vmovl──► int16×8  ──split──► int32×4 (lo) + int32×4 (hi)
                                              │
                                    vmlaq_n_s32 (32-bit MAC)
                                              │
                                    vqmovn_s32 → vqmovun_s16 → uint8×8
```

**Performance (640×480):**

| | Integer | neon_v3 |
|--|---------|---------|
| YCC→RGB Ir | 17,943,324 | 15,982,182 |
| Speedup | — | ~1.12× |

Smaller gain than RGB→YCC because **chroma upsampling** (`chrominance_array_upsample`) still runs scalar before NEON convert. Upsampling fills `Cb_temp`/`Cr_temp` full-resolution buffers — memory-bound work SIMD doesn't eliminate.

**Prerequisite:** `CSC_YCC_to_RGB()` calls `chrominance_array_upsample()` once before routine 4 runs (Matt's fix moved it out of the per-pixel loop — dropped YCC→RGB Ir from **17.4M → 194k** on small image before NEON was even applied).

---

## 6. Assembly analysis — how and what we found

### Methodology

```bash
arm-none-linux-gnueabihf-gcc -march=armv7-a -mfpu=neon -mfloat-abi=hard -S
```

Compiled each routine at **-O0** and **-O2**, counted instructions in the **inner loop body** vs **full image** via Cachegrind (`make measure`).

### Per-iteration loop body (-O2)

| Routine | Instructions (loop body) |
|---------|---------------------------|
| float | 195 |
| integer | 216 |
| neon v1 | 170 |
| neon tiled | 235 |
| LUT | 327 |
| **neon_v2** | **279** |

**Key lesson:** neon_v2's loop body is *larger* than integer's. Judging SIMD by one iteration is misleading.

### Full-image dynamic instructions (640×480, Cachegrind)

| Direction | Routine | Total Ir | vs baseline |
|-----------|---------|----------|-------------|
| RGB→YCC | integer | 22,618,342 | 1.00× |
| RGB→YCC | **neon_v2** | **8,924,866** | **2.53× fewer** |
| YCC→RGB | integer | 17,943,324 | 1.00× |
| YCC→RGB | **neon_v3** | **15,982,182** | **1.12× fewer** |

### What assembly revealed about NEON codegen

Typical neon_v2 inner loop maps to:
- **`vld1.8`** — contiguous 8-byte loads (good cache line use)
- **`vmovl.u8`** — zero-extend bytes to halfwords
- **`vmlal.u16` / `vmlsl.u16`** — widening multiply-accumulate
- **`vshrn.u16`** — narrow after shift
- **`vst1.8`** — store 8 results

At `-O2`, the compiler keeps coefficients in scalar registers and broadcasts into NEON ops (`vmlaq_n_u16`), avoiding reloading constants each lane.

---

## 7. End-to-end results (from final benchmark suite)

### Wall time (best config: `neon` = RGB routine 6 + YCC routine 4)

| Image | Baseline | neon | Improvement |
|-------|----------|------|-------------|
| 64×48 | 0.100 ms | 0.060 ms | **~40% faster** |
| 640×480 | 9.25 ms | 6.12 ms | **~34% faster** |

### Quality (unchanged across all configs)

| Image | mean_abs_delta | diff_max |
|-------|----------------|----------|
| 64×48 | 4.92 | 113 |
| 640×480 | 1.85 | 198 |

Chroma subsampling guarantees loss; optimizations did not make it worse.

### What did NOT help

| Optimization | Verdict |
|--------------|---------|
| LUT | More instructions, more L1 misses, slower |
| Tiling (16×16) | Extra loop overhead, same LL misses |
| NEON v1 | SIMD without enough lane utilization |

---

## 8. Likely instructor questions — short answers

**Q: Why NEON intrinsics**  
Upside, it handels instruction scheduling which can be very difficult to optimize with hand-coded assembly.
Easier to debug, readability, easier to maintain
Downside, is it's compiler dependant and different compilers, can produce different assembly code (for better/worse)

**Q: Why K=8 and not K=16?**  
A: 8-bit channels only need ~8 fractional bits. K=16 makes intermediate products larger, increasing overflow risk without visible quality gain.

**Q: Why did neon_v2's assembly loop have MORE instructions than integer?**  
A: Wider vectors do more work per iteration but each iteration is heavier. Total image instructions fell 2.5× because the outer loop ran ~8× fewer times.

**Q: Why did the first YCC NEON produce a black image?**  
A: int16 accumulator overflow. D1×(Y−16) alone can exceed 32,767. vmlaq_n_s16 wraps; vqmovun saturates wrapped values to 0.

**Q: Why is YCC→RGB speedup smaller than RGB→YCC?**  
A: (1) int32 MACs are 4-wide, not 8-wide. (2) Scalar chroma upsampling into full-resolution temp buffers still dominates. (3) Larger D coefficients limit how aggressively we can use 16-bit math.

**Q: Why didn't tiling help cache?**  
A: LL misses ~273k on 640×480 regardless of variant — working set already fit reasonably. Tile management added instructions without reducing misses.

**Q: Why didn't LUT help?**  
A: Traded cheap multiplies for 9 memory loads per pixel. ARM integer MAC is fast; memory isn't free.

**Q: What's the difference between vmlaq_n_s16 and vmlaq_n_s32?**  
A: Same fused multiply-add, different lane width. s16 is faster but overflows on YCC→RGB coefficients; s32 is safe.

**Q: What does vqmovun do?**  
A: Saturating narrow — clamps to [0, 255] when converting signed wider results to unsigned 8-bit. The `q` means saturate; it cannot fix overflow that already happened in the MAC.

**Q: Why primary metric = Cachegrind Ir, not wall time?**  
A: QEMU ARM VM emulates NEON; wall time is inflated and noisy. Instruction count is reproducible and shows algorithmic improvement. Wall time on real Pi/ARMv8 confirmed ~34–40% speedup.

**Q: What's left to optimize?**  
A: Vectorize chroma upsampling (still scalar), reduce temp-buffer traffic (`Cb_temp`/`Cr_temp`), possibly fuse upsample + convert (was explored; removed from final code).

---

## 9. Code pointers for live demo

| Topic | File | Lines (approx) |
|-------|------|----------------|
| Coefficients & K | `CSC_global.h` | 3–80 |
| NEON v1 | `CSC_RGB_to_YCC.c` | 209–257 |
| Tiling wrapper | `CSC_RGB_to_YCC.c` | 260–271 |
| LUT init + use | `CSC_RGB_to_YCC.c` | 275–317 |
| **NEON v2 (forward)** | `CSC_RGB_to_YCC.c` | 321–409 |
| Broken YCC v2 | `CSC_YCC_to_RGB.c` | 252–293 |
| **NEON v3 strip helper** | `CSC_YCC_to_RGB.c` | 301–353 |
| Routine dispatch | both `.c` files | bottom `CSC_*()` functions |

---

## 10. One-sentence summary

Your partner moved from "SIMD in name only" (4 pixels, empty register lanes) to **8-wide memory operations** with correctly sized accumulators — achieving **2.5× fewer instructions on RGB→YCC** and proving that **wider SIMD beats LUT and tiling** on this workload, while discovering that **inverse conversion needs 32-bit MACs** because fixed-point headroom is direction-dependent.
