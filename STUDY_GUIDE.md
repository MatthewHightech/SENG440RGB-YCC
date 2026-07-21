# SENG440 Study Guide — RGB↔YCC Color Space Conversion

## Project Goal

Implement RGB↔YCC color space conversion on an ARM-based embedded system, optimizing progressively from float C → fixed-point C → ARM assembly → NEON intrinsics. Produce a technical report documenting the design process and performance at each stage.

---

## 1. Why YCbCr?

RGB stores equal weight across three channels. Human vision is far more sensitive to brightness than color. YCbCr exploits this:

- **Y** — luminance (brightness), full resolution
- **Cb** — blue-difference chrominance
- **Cr** — red-difference chrominance

Once separated, Cb and Cr can be stored at quarter resolution (4:2:0 subsampling) with nearly no perceptible quality loss. This is the foundation of JPEG and most video codecs.

---

## 2. The Conversion Math

### RGB → YCbCr (BT.601, studio swing)

```
Y  = 16  + 0.257·R + 0.504·G + 0.098·B
Cb = 128 - 0.148·R - 0.291·G + 0.439·B
Cr = 128 + 0.439·R - 0.368·G - 0.071·B
```

Offsets (16, 128, 128) shift into studio swing: Y ∈ [16,235], Cb/Cr ∈ [16,240]. This leaves headroom at both ends — an industry standard (BT.601).

### YCbCr → RGB

```
R = 1.164·(Y-16) + 1.596·(Cr-128)
G = 1.164·(Y-16) - 0.813·(Cr-128) - 0.391·(Cb-128)
B = 1.164·(Y-16) + 2.018·(Cb-128)
```

Saturation clamping is required on the inverse — values can go below 0 or above 255. Without it, wraparound produces false colours (visible as colour artifacts in testing).

---

## 3. 4:2:0 Chroma Subsampling

For every 2×2 block of pixels:
- Keep all 4 Y values (full resolution)
- Keep only 1 Cb and 1 Cr value (quarter resolution)

Output array sizes: `Y[64][48]`, `Cb[32][24]`, `Cr[32][24]`.

### Downsampling modes (implemented)
- **Mode 0** — return zero (no chrominance, for testing)
- **Mode 1** — keep top-left pixel of each 2×2 block (fast, lower quality)
- **Mode 2** — average all four pixels (better quality, more computation)

### Upsampling modes (inverse)
- **Mode 1** — replicate one pixel into four (nearest neighbour)
- **Mode 2** — interpolate between pixels

**Known edge case:** The reference implementation has a loop condition bug (`row<` instead of `col<`) in the bottom-edge upsampling for Cb, causing that row to be skipped. Our implementation fixes this with `col<`, which produces slightly different (more correct) output than the reference.

---

## 4. Fixed-Point Arithmetic

### Why faster on embedded?
- No FPU pipeline stalls
- Integer multiply/shift has predictable cycle counts
- Better compiler vectorization opportunities
- Lower power consumption

### The K=8 scheme

Coefficients are pre-scaled by 2^K = 256:
- 0.257 → 66 (= round(0.257 × 256))
- 0.504 → 129
- 0.098 → 25
- etc.

The computation for Y on one pixel:
```c
Y = (16<<K) + C11*R + C12*G + C13*B;
Y += (1 << (K-1));   // round to nearest
Y = Y >> K;          // scale back down
```

### Why `16 << K` not just `16`?
Everything in the accumulator is scaled by 2^K. The constant 16 must be shifted into the same scaled world before addition. `16 + C11*R` would add an unscaled value to a scaled sum — wrong.

### Why K=8 specifically?
Overflow check (worst case — all channels at 255, largest coefficients):
```
(16<<8) + 66*255 + 129*255 + 25*255 = 4096 + 16830 + 32895 + 6375 = 60196
```
Fits comfortably in a 32-bit int (max ~2.1 billion). K=16 would risk overflow.

Error bound: ±1/2^K = ±1/256 in unscaled domain → less than 1 LSB of the 8-bit output. Rounding error is sub-pixel and invisible.

### Rounding: why `+= (1 << (K-1))`?
Right-shift truncates toward zero — always rounds down, introducing a systematic downward bias across every pixel. The bias is visible as a subtle darkening/colour shift in the image.

Adding `1<<(K-1)` (= 0.5 in the scaled world) before the shift implements round-half-up: values whose fractional part ≥ 0.5 round up, others round down. Error is distributed randomly rather than accumulating in one direction.

---

## 5. Profiling Results

**Platform:** ARM64 (AArch64), Cortex-A57, QEMU emulation  
**Method:** gprof, 10,000 iterations per combination  
**Tool:** `make profile` — runs all 6 combinations automatically

| | Mode 0 (no chroma) | Mode 1 (keep 1px) | Mode 2 (average 4px) |
|---|---|---|---|
| **Float** | 288 µs/call | 361 µs/call | 695 µs/call |
| **Integer** | 57 µs/call | 42 µs/call | 62 µs/call |
| **Speedup** | 5.1× | 8.6× | 11.2× |

Key observations:
- Integer is 5–8× faster across all modes
- Float mode 2 costs nearly 2× mode 1 due to the extra averaging arithmetic
- Integer mode 2 is not significantly worse than mode 1 — the averaging is cheap in integer arithmetic
- `CSC_RGB_to_YCC` accounts for ~100% of execution time — confirmed bottleneck

---

## 6. ARM Architecture Notes

### 32-bit (ARMv7 / Cortex-A7) vs 64-bit (AArch64 / Cortex-A57)

This project uses the 64-bit VM (Cortex-A57). The course examples reference 32-bit ARM. Key differences:

| | ARM32 | AArch64 |
|---|---|---|
| General registers | 16 × 32-bit | 31 × 64-bit |
| NEON registers | 16 × 128-bit | 32 × 128-bit |
| Calling convention | AAPCS | AAPCS64 |

If the examiner asks why your assembly looks different from the slides — this is the answer.

### Generating assembly
```bash
aarch64-linux-gnu-gcc -O2 -S -o CSC_RGB_to_YCC.s CSC_RGB_to_YCC.c
```
The `-S` flag stops after compilation and outputs human-readable assembly.

---

## 7. Project Design Flow (from Lesson 100)

1. ✅ Float C implementation — verified against reference
2. ✅ Fixed-point integer implementation — 5–11× speedup measured
3. → Generate and inspect ARM64 assembly
4. → Optimize assembly (loop unrolling, inlining, software pipelining)
5. → NEON intrinsics (process multiple pixels per instruction)
6. → Firmware section: microcode analysis (vertical + horizontal issue slots)
7. → Hardware section: latency estimate for custom computing unit
8. → Technical report

---

## 8. Report Structure (required)

1. Front page — title, author, student number, submission date
2. Introduction — domain description, performance requirements, contributions
3. Theoretical background
4. Design process
5. Performance/cost evaluation
6. Conclusions
7. Bibliography

Max 20 pages, 11 or 12pt, single spaced.

---

## 9. Likely Oral Exam Questions

**Fixed-point:**
- Why is fixed-point faster than float on embedded processors?
- Why K=8? What happens if you use K=16?
- What does `+= (1 << (K-1))` do and why does it matter for image quality?
- What is the maximum intermediate value and does it overflow a 32-bit int?

**Profiling:**
- How did you identify the bottleneck? (gprof, 10k iterations, ~100% time in CSC_RGB_to_YCC)
- Why run 10,000 iterations? (64×48 image too small for single-run profiling)
- Why does mode 2 cost more in float but not in integer?

**Architecture:**
- Why does your assembly differ from the course slides? (64-bit vs 32-bit ARM)
- How many NEON registers does AArch64 have vs ARM32?
- What is Amdahl's Law and why does it justify optimizing CSC_RGB_to_YCC?

**Color space:**
- Why are Cb and Cr stored at half resolution?
- What is studio swing and why are the offsets 16 and 128?
- Why does the inverse conversion need saturation clamping but the forward conversion doesn't?
