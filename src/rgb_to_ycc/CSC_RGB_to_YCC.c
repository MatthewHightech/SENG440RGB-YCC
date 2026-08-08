// Copyright 2023 Mihai SIMA (mihai.sima@ieee.org).  All rights reserved.
// Color Space Conversion (CSC) in fixed-point arithmetic
// RGB to YCC conversion

// #include <stdio.h>
#include "CSC_global.h"
#include <arm_neon.h>
#include <stdint.h>

// private data

// LUT tables: 9 arrays of 256 entries, one per (output, input channel) pair.
// Negative coefficients stored negative so compute can just add, no
// mixed add/subtract per pixel.
static int lut_Y_R[256],  lut_Y_G[256],  lut_Y_B[256];
static int lut_Cb_R[256], lut_Cb_G[256], lut_Cb_B[256];
static int lut_Cr_R[256], lut_Cr_G[256], lut_Cr_B[256];

// private prototypes
// =======
static void CSC_RGB_to_YCC_brute_force_float(int row, int col);

// =======
static void CSC_RGB_to_YCC_brute_force_int(int row, int col);

// =======
static void CSC_RGB_to_YCC_neon(int row, int col);

// =======
static void CSC_RGB_to_YCC_neon_tiled(void);

// =======
static void lut_init(void);

// =======
static void CSC_RGB_to_YCC_lut(int row, int col);

// =======
static void CSC_RGB_to_YCC_neon_v2(void);

// =======
static uint8_t chrominance_downsample(uint8_t C_pixel_1, uint8_t C_pixel_2,
                                      uint8_t C_pixel_3, uint8_t C_pixel_4);

// private definitions
// =======
static void CSC_RGB_to_YCC_brute_force_float(int row, int col) {
  //
  uint8_t Cb_pixel_00, Cb_pixel_01;
  uint8_t Cb_pixel_10, Cb_pixel_11;
  uint8_t Cr_pixel_00, Cr_pixel_01;
  uint8_t Cr_pixel_10, Cr_pixel_11;

  Y[row + 0][col + 0] =
      (uint8_t)(16.0 + 0.257 * R[row + 0][col + 0] +
                0.504 * G[row + 0][col + 0] + 0.098 * B[row + 0][col + 0]);
  Y[row + 0][col + 1] =
      (uint8_t)(16.0 + 0.257 * R[row + 0][col + 1] +
                0.504 * G[row + 0][col + 1] + 0.098 * B[row + 0][col + 1]);
  Y[row + 1][col + 0] =
      (uint8_t)(16.0 + 0.257 * R[row + 1][col + 0] +
                0.504 * G[row + 1][col + 0] + 0.098 * B[row + 1][col + 0]);
  Y[row + 1][col + 1] =
      (uint8_t)(16.0 + 0.257 * R[row + 1][col + 1] +
                0.504 * G[row + 1][col + 1] + 0.098 * B[row + 1][col + 1]);

  Cb_pixel_00 =
      (uint8_t)(128.0 - 0.148 * R[row + 0][col + 0] -
                0.291 * G[row + 0][col + 0] + 0.439 * B[row + 0][col + 0]);
  Cb_pixel_01 =
      (uint8_t)(128.0 - 0.148 * R[row + 0][col + 1] -
                0.291 * G[row + 0][col + 1] + 0.439 * B[row + 0][col + 1]);
  Cb_pixel_10 =
      (uint8_t)(128.0 - 0.148 * R[row + 1][col + 0] -
                0.291 * G[row + 1][col + 0] + 0.439 * B[row + 1][col + 0]);
  Cb_pixel_11 =
      (uint8_t)(128.0 - 0.148 * R[row + 1][col + 1] -
                0.291 * G[row + 1][col + 1] + 0.439 * B[row + 1][col + 1]);

  Cr_pixel_00 =
      (uint8_t)(128.0 + 0.439 * R[row + 0][col + 0] -
                0.368 * G[row + 0][col + 0] - 0.071 * B[row + 0][col + 0]);
  Cr_pixel_01 =
      (uint8_t)(128.0 + 0.439 * R[row + 0][col + 1] -
                0.368 * G[row + 0][col + 1] - 0.071 * B[row + 0][col + 1]);
  Cr_pixel_10 =
      (uint8_t)(128.0 + 0.439 * R[row + 1][col + 0] -
                0.368 * G[row + 1][col + 0] - 0.071 * B[row + 1][col + 0]);
  Cr_pixel_11 =
      (uint8_t)(128.0 + 0.439 * R[row + 1][col + 1] -
                0.368 * G[row + 1][col + 1] - 0.071 * B[row + 1][col + 1]);

  Cb[row >> 1][col >> 1] = chrominance_downsample(Cb_pixel_00, Cb_pixel_01,
                                                  Cb_pixel_10, Cb_pixel_11);

  Cr[row >> 1][col >> 1] = chrominance_downsample(Cr_pixel_00, Cr_pixel_01,
                                                  Cr_pixel_10, Cr_pixel_11);
} // END of CSC_RGB_to_YCC_brute_force_float()

// =======
static void CSC_RGB_to_YCC_brute_force_int(int row, int col) {
  //
  int R_pixel_00, R_pixel_01, R_pixel_10, R_pixel_11;
  int G_pixel_00, G_pixel_01, G_pixel_10, G_pixel_11;
  int B_pixel_00, B_pixel_01, B_pixel_10, B_pixel_11;

  int Y_pixel_00, Y_pixel_01, Y_pixel_10, Y_pixel_11;
  int Cb_pixel_00, Cb_pixel_01, Cb_pixel_10, Cb_pixel_11;
  int Cr_pixel_00, Cr_pixel_01, Cr_pixel_10, Cr_pixel_11;

  R_pixel_00 = (int)R[row + 0][col + 0];
  R_pixel_01 = (int)R[row + 0][col + 1];
  R_pixel_10 = (int)R[row + 1][col + 0];
  R_pixel_11 = (int)R[row + 1][col + 1];

  G_pixel_00 = (int)G[row + 0][col + 0];
  G_pixel_01 = (int)G[row + 0][col + 1];
  G_pixel_10 = (int)G[row + 1][col + 0];
  G_pixel_11 = (int)G[row + 1][col + 1];

  B_pixel_00 = (int)B[row + 0][col + 0];
  B_pixel_01 = (int)B[row + 0][col + 1];
  B_pixel_10 = (int)B[row + 1][col + 0];
  B_pixel_11 = (int)B[row + 1][col + 1];

  Y_pixel_00 =
      (16 << (K)) + C11 * R_pixel_00 + C12 * G_pixel_00 + C13 * B_pixel_00;
  Y_pixel_00 += (1 << (K - 1)); // rounding
  Y_pixel_00 = Y_pixel_00 >> K;

  Y_pixel_01 =
      (16 << (K)) + C11 * R_pixel_01 + C12 * G_pixel_01 + C13 * B_pixel_01;
  Y_pixel_01 += (1 << (K - 1)); // rounding
  Y_pixel_01 = Y_pixel_01 >> K;

  Y_pixel_10 =
      (16 << (K)) + C11 * R_pixel_10 + C12 * G_pixel_10 + C13 * B_pixel_10;
  Y_pixel_10 += (1 << (K - 1)); // rounding
  Y_pixel_10 = Y_pixel_10 >> K;

  Y_pixel_11 =
      (16 << (K)) + C11 * R_pixel_11 + C12 * G_pixel_11 + C13 * B_pixel_11;
  Y_pixel_11 += (1 << (K - 1)); // rounding
  Y_pixel_11 = Y_pixel_11 >> K;

  Y[row + 0][col + 0] = (uint8_t)Y_pixel_00;
  Y[row + 0][col + 1] = (uint8_t)Y_pixel_01;
  Y[row + 1][col + 0] = (uint8_t)Y_pixel_10;
  Y[row + 1][col + 1] = (uint8_t)Y_pixel_11;

  Cb_pixel_00 =
      (128 << (K)) - C21 * R_pixel_00 - C22 * G_pixel_00 + C23 * B_pixel_00;
  Cb_pixel_00 += (1 << (K - 1)); // rounding
  Cb_pixel_00 = Cb_pixel_00 >> K;

  Cb_pixel_01 =
      (128 << (K)) - C21 * R_pixel_01 - C22 * G_pixel_01 + C23 * B_pixel_01;
  Cb_pixel_01 += (1 << (K - 1)); // rounding
  Cb_pixel_01 = Cb_pixel_01 >> K;

  Cb_pixel_10 =
      (128 << (K)) - C21 * R_pixel_10 - C22 * G_pixel_10 + C23 * B_pixel_10;
  Cb_pixel_10 += (1 << (K - 1)); // rounding
  Cb_pixel_10 = Cb_pixel_10 >> K;

  Cb_pixel_11 =
      (128 << (K)) - C21 * R_pixel_11 - C22 * G_pixel_11 + C23 * B_pixel_11;
  Cb_pixel_11 += (1 << (K - 1)); // rounding
  Cb_pixel_11 = Cb_pixel_11 >> K;

  Cr_pixel_00 =
      (128 << (K)) + C31 * R_pixel_00 - C32 * G_pixel_00 - C33 * B_pixel_00;
  Cr_pixel_00 += (1 << (K - 1)); // rounding
  Cr_pixel_00 = Cr_pixel_00 >> K;

  Cr_pixel_01 =
      (128 << (K)) + C31 * R_pixel_01 - C32 * G_pixel_01 - C33 * B_pixel_01;
  Cr_pixel_01 += (1 << (K - 1)); // rounding
  Cr_pixel_01 = Cr_pixel_01 >> K;

  Cr_pixel_10 =
      (128 << (K)) + C31 * R_pixel_10 - C32 * G_pixel_10 - C33 * B_pixel_10;
  Cr_pixel_10 += (1 << (K - 1)); // rounding
  Cr_pixel_10 = Cr_pixel_10 >> K;

  Cr_pixel_11 =
      (128 << (K)) + C31 * R_pixel_11 - C32 * G_pixel_11 - C33 * B_pixel_11;
  Cr_pixel_11 += (1 << (K - 1)); // rounding
  Cr_pixel_11 = Cr_pixel_11 >> K;

  Cb[row >> 1][col >> 1] =
      chrominance_downsample((uint8_t)Cb_pixel_00, (uint8_t)Cb_pixel_01,
                             (uint8_t)Cb_pixel_10, (uint8_t)Cb_pixel_11);

  Cr[row >> 1][col >> 1] =
      chrominance_downsample((uint8_t)Cr_pixel_00, (uint8_t)Cr_pixel_01,
                             (uint8_t)Cr_pixel_10, (uint8_t)Cr_pixel_11);
} // END of CSC_RGB_to_YCC_brute_force_int()

// =======
static void CSC_RGB_to_YCC_neon(int row, int col) {
  //
  int32x4_t R_vec, G_vec, B_vec, Y_vec, Cb_vec, Cr_vec;

  // Turn the above into a NEON intrinsic call
  R_vec = (int32x4_t){R[row + 0][col + 0], R[row + 0][col + 1],
                      R[row + 1][col + 0], R[row + 1][col + 1]};
  G_vec = (int32x4_t){G[row + 0][col + 0], G[row + 0][col + 1],
                      G[row + 1][col + 0], G[row + 1][col + 1]};
  B_vec = (int32x4_t){B[row + 0][col + 0], B[row + 0][col + 1],
                      B[row + 1][col + 0], B[row + 1][col + 1]};

  // Build accumulator/initial value
  Y_vec = vdupq_n_s32((16 << K) + (1 << (K - 1)));
  // Perform constant/scalar multiple to each RGC vector
  Y_vec = vmlaq_n_s32(Y_vec, R_vec, C11);
  Y_vec = vmlaq_n_s32(Y_vec, G_vec, C12);
  Y_vec = vmlaq_n_s32(Y_vec, B_vec, C13);
  // Shift right by K on each
  Y_vec = vshrq_n_s32(Y_vec, K);

  // Store back to original array
  Y[row + 0][col + 0] = (uint8_t)vgetq_lane_s32(Y_vec, 0);
  Y[row + 0][col + 1] = (uint8_t)vgetq_lane_s32(Y_vec, 1);
  Y[row + 1][col + 0] = (uint8_t)vgetq_lane_s32(Y_vec, 2);
  Y[row + 1][col + 1] = (uint8_t)vgetq_lane_s32(Y_vec, 3);

  // Cb
  Cb_vec = vdupq_n_s32((128 << K) + (1 << (K - 1)));
  Cb_vec = vmlsq_n_s32(Cb_vec, R_vec, C21);
  Cb_vec = vmlsq_n_s32(Cb_vec, G_vec, C22);
  Cb_vec = vmlaq_n_s32(Cb_vec, B_vec, C23);
  Cb_vec = vshrq_n_s32(Cb_vec, K);

  // Cr
  Cr_vec = vdupq_n_s32((128 << K) + (1 << (K - 1)));
  Cr_vec = vmlaq_n_s32(Cr_vec, R_vec, C31);
  Cr_vec = vmlsq_n_s32(Cr_vec, G_vec, C32);
  Cr_vec = vmlsq_n_s32(Cr_vec, B_vec, C33);
  Cr_vec = vshrq_n_s32(Cr_vec, K);

  Cb[row >> 1][col >> 1] = chrominance_downsample(
      (uint8_t)vgetq_lane_s32(Cb_vec, 0), (uint8_t)vgetq_lane_s32(Cb_vec, 1),
      (uint8_t)vgetq_lane_s32(Cb_vec, 2), (uint8_t)vgetq_lane_s32(Cb_vec, 3));

  Cr[row >> 1][col >> 1] = chrominance_downsample(
      (uint8_t)vgetq_lane_s32(Cr_vec, 0), (uint8_t)vgetq_lane_s32(Cr_vec, 1),
      (uint8_t)vgetq_lane_s32(Cr_vec, 2), (uint8_t)vgetq_lane_s32(Cr_vec, 3));
} // END of CSC_RGB_to_YCC_neon()

// =======
static void CSC_RGB_to_YCC_neon_tiled(void) {
  int tile_row, tile_col, row, col;
  for (tile_row = 0; tile_row < IMAGE_ROW_SIZE; tile_row += TILE_SIZE) {
    for (tile_col = 0; tile_col < IMAGE_COL_SIZE; tile_col += TILE_SIZE) {
      for (row = tile_row; row < tile_row + TILE_SIZE; row += 2) {
        for (col = tile_col; col < tile_col + TILE_SIZE; col += 2) {
          CSC_RGB_to_YCC_neon(row, col);
        }
      }
    }
  }
} // END of CSC_RGB_to_YCC_neon_tiled()

// =======
static void lut_init(void) {
  int i;
  for (i = 0; i < 256; i++) {
    lut_Y_R[i]  =  C11 * i;
    lut_Y_G[i]  =  C12 * i;
    lut_Y_B[i]  =  C13 * i;
    lut_Cb_R[i] = -C21 * i;
    lut_Cb_G[i] = -C22 * i;
    lut_Cb_B[i] =  C23 * i;
    lut_Cr_R[i] =  C31 * i;
    lut_Cr_G[i] = -C32 * i;
    lut_Cr_B[i] = -C33 * i;
  }
} // END of lut_init()

// =======
static void CSC_RGB_to_YCC_lut(int row, int col) {
  int r00 = R[row+0][col+0], g00 = G[row+0][col+0], b00 = B[row+0][col+0];
  int r01 = R[row+0][col+1], g01 = G[row+0][col+1], b01 = B[row+0][col+1];
  int r10 = R[row+1][col+0], g10 = G[row+1][col+0], b10 = B[row+1][col+0];
  int r11 = R[row+1][col+1], g11 = G[row+1][col+1], b11 = B[row+1][col+1];

  int bias_Y = (16  << K) + (1 << (K-1));
  int bias_C = (128 << K) + (1 << (K-1));

  Y[row+0][col+0] = (uint8_t)((bias_Y + lut_Y_R[r00] + lut_Y_G[g00] + lut_Y_B[b00]) >> K);
  Y[row+0][col+1] = (uint8_t)((bias_Y + lut_Y_R[r01] + lut_Y_G[g01] + lut_Y_B[b01]) >> K);
  Y[row+1][col+0] = (uint8_t)((bias_Y + lut_Y_R[r10] + lut_Y_G[g10] + lut_Y_B[b10]) >> K);
  Y[row+1][col+1] = (uint8_t)((bias_Y + lut_Y_R[r11] + lut_Y_G[g11] + lut_Y_B[b11]) >> K);

  uint8_t Cb00 = (uint8_t)((bias_C + lut_Cb_R[r00] + lut_Cb_G[g00] + lut_Cb_B[b00]) >> K);
  uint8_t Cb01 = (uint8_t)((bias_C + lut_Cb_R[r01] + lut_Cb_G[g01] + lut_Cb_B[b01]) >> K);
  uint8_t Cb10 = (uint8_t)((bias_C + lut_Cb_R[r10] + lut_Cb_G[g10] + lut_Cb_B[b10]) >> K);
  uint8_t Cb11 = (uint8_t)((bias_C + lut_Cb_R[r11] + lut_Cb_G[g11] + lut_Cb_B[b11]) >> K);

  uint8_t Cr00 = (uint8_t)((bias_C + lut_Cr_R[r00] + lut_Cr_G[g00] + lut_Cr_B[b00]) >> K);
  uint8_t Cr01 = (uint8_t)((bias_C + lut_Cr_R[r01] + lut_Cr_G[g01] + lut_Cr_B[b01]) >> K);
  uint8_t Cr10 = (uint8_t)((bias_C + lut_Cr_R[r10] + lut_Cr_G[g10] + lut_Cr_B[b10]) >> K);
  uint8_t Cr11 = (uint8_t)((bias_C + lut_Cr_R[r11] + lut_Cr_G[g11] + lut_Cr_B[b11]) >> K);

  Cb[row>>1][col>>1] = chrominance_downsample(Cb00, Cb01, Cb10, Cb11);
  Cr[row>>1][col>>1] = chrominance_downsample(Cr00, Cr01, Cr10, Cr11);
} // END of CSC_RGB_to_YCC_lut()

// =======
static void CSC_RGB_to_YCC_neon_v2(void) {
  int row, col;
  for (row = 0; row < IMAGE_ROW_SIZE; row += 2) {
    for (col = 0; col < IMAGE_COL_SIZE; col += 8) {

      // Load 8 consecutive pixels per channel per row, 1 NEON instruction
      uint8x8_t r8_r0 = vld1_u8(&R[row][col]);
      uint8x8_t g8_r0 = vld1_u8(&G[row][col]);
      uint8x8_t b8_r0 = vld1_u8(&B[row][col]);
      uint8x8_t r8_r1 = vld1_u8(&R[row + 1][col]);
      uint8x8_t g8_r1 = vld1_u8(&G[row + 1][col]);
      uint8x8_t b8_r1 = vld1_u8(&B[row + 1][col]);

      // Widen to 16-bit so products don't overflow
      uint16x8_t r_r0 = vmovl_u8(r8_r0);
      uint16x8_t g_r0 = vmovl_u8(g8_r0);
      uint16x8_t b_r0 = vmovl_u8(b8_r0);
      uint16x8_t r_r1 = vmovl_u8(r8_r1);
      uint16x8_t g_r1 = vmovl_u8(g8_r1);
      uint16x8_t b_r1 = vmovl_u8(b8_r1);

      // Y: 8 pixels per row in parallel, narrow and store in one NEON store
      uint16x8_t y_r0 = vdupq_n_u16((16 << K) + (1 << (K - 1)));
      y_r0 = vmlaq_n_u16(y_r0, r_r0, C11);
      y_r0 = vmlaq_n_u16(y_r0, g_r0, C12);
      y_r0 = vmlaq_n_u16(y_r0, b_r0, C13);
      vst1_u8(&Y[row][col], vmovn_u16(vshrq_n_u16(y_r0, K)));

      uint16x8_t y_r1 = vdupq_n_u16((16 << K) + (1 << (K - 1)));
      y_r1 = vmlaq_n_u16(y_r1, r_r1, C11);
      y_r1 = vmlaq_n_u16(y_r1, g_r1, C12);
      y_r1 = vmlaq_n_u16(y_r1, b_r1, C13);
      vst1_u8(&Y[row + 1][col], vmovn_u16(vshrq_n_u16(y_r1, K)));

      // Cb: compute 8 values per row, narrow to u8
      uint16x8_t cb_r0 = vdupq_n_u16((128 << K) + (1 << (K - 1)));
      cb_r0 = vmlsq_n_u16(cb_r0, r_r0, C21);
      cb_r0 = vmlsq_n_u16(cb_r0, g_r0, C22);
      cb_r0 = vmlaq_n_u16(cb_r0, b_r0, C23);
      uint8x8_t cb_r0_u8 = vmovn_u16(vshrq_n_u16(cb_r0, K));

      uint16x8_t cb_r1 = vdupq_n_u16((128 << K) + (1 << (K - 1)));
      cb_r1 = vmlsq_n_u16(cb_r1, r_r1, C21);
      cb_r1 = vmlsq_n_u16(cb_r1, g_r1, C22);
      cb_r1 = vmlaq_n_u16(cb_r1, b_r1, C23);
      uint8x8_t cb_r1_u8 = vmovn_u16(vshrq_n_u16(cb_r1, K));

      // Cr: compute 8 values per row, narrow to u8
      uint16x8_t cr_r0 = vdupq_n_u16((128 << K) + (1 << (K - 1)));
      cr_r0 = vmlaq_n_u16(cr_r0, r_r0, C31);
      cr_r0 = vmlsq_n_u16(cr_r0, g_r0, C32);
      cr_r0 = vmlsq_n_u16(cr_r0, b_r0, C33);
      uint8x8_t cr_r0_u8 = vmovn_u16(vshrq_n_u16(cr_r0, K));

      uint16x8_t cr_r1 = vdupq_n_u16((128 << K) + (1 << (K - 1)));
      cr_r1 = vmlaq_n_u16(cr_r1, r_r1, C31);
      cr_r1 = vmlsq_n_u16(cr_r1, g_r1, C32);
      cr_r1 = vmlsq_n_u16(cr_r1, b_r1, C33);
      uint8x8_t cr_r1_u8 = vmovn_u16(vshrq_n_u16(cr_r1, K));

      // Downsample: 4 x 2×2 blocks per strip
      Cb[row>>1][(col>>1)+0] = chrominance_downsample(
          vget_lane_u8(cb_r0_u8,0), vget_lane_u8(cb_r0_u8,1),
          vget_lane_u8(cb_r1_u8,0), vget_lane_u8(cb_r1_u8,1));
      Cb[row>>1][(col>>1)+1] = chrominance_downsample(
          vget_lane_u8(cb_r0_u8,2), vget_lane_u8(cb_r0_u8,3),
          vget_lane_u8(cb_r1_u8,2), vget_lane_u8(cb_r1_u8,3));
      Cb[row>>1][(col>>1)+2] = chrominance_downsample(
          vget_lane_u8(cb_r0_u8,4), vget_lane_u8(cb_r0_u8,5),
          vget_lane_u8(cb_r1_u8,4), vget_lane_u8(cb_r1_u8,5));
      Cb[row>>1][(col>>1)+3] = chrominance_downsample(
          vget_lane_u8(cb_r0_u8,6), vget_lane_u8(cb_r0_u8,7),
          vget_lane_u8(cb_r1_u8,6), vget_lane_u8(cb_r1_u8,7));

      Cr[row>>1][(col>>1)+0] = chrominance_downsample(
          vget_lane_u8(cr_r0_u8,0), vget_lane_u8(cr_r0_u8,1),
          vget_lane_u8(cr_r1_u8,0), vget_lane_u8(cr_r1_u8,1));
      Cr[row>>1][(col>>1)+1] = chrominance_downsample(
          vget_lane_u8(cr_r0_u8,2), vget_lane_u8(cr_r0_u8,3),
          vget_lane_u8(cr_r1_u8,2), vget_lane_u8(cr_r1_u8,3));
      Cr[row>>1][(col>>1)+2] = chrominance_downsample(
          vget_lane_u8(cr_r0_u8,4), vget_lane_u8(cr_r0_u8,5),
          vget_lane_u8(cr_r1_u8,4), vget_lane_u8(cr_r1_u8,5));
      Cr[row>>1][(col>>1)+3] = chrominance_downsample(
          vget_lane_u8(cr_r0_u8,6), vget_lane_u8(cr_r0_u8,7),
          vget_lane_u8(cr_r1_u8,6), vget_lane_u8(cr_r1_u8,7));
    }
  }
} // END of CSC_RGB_to_YCC_neon_v2()

// =======
static uint8_t chrominance_downsample(uint8_t C_pixel_00, uint8_t C_pixel_01,
                                      uint8_t C_pixel_10, uint8_t C_pixel_11) {

  int temp;

  switch (CHROMINANCE_DOWNSAMPLING_MODE) {
  case 0:
    return (0);
  case 1:
    return (C_pixel_00);
  case 2:
    temp =
        (int)C_pixel_00 + (int)C_pixel_01 + (int)C_pixel_10 + (int)C_pixel_11;
    temp += (1 << 1); // rounding
    temp = temp >> 2;
    return ((uint8_t)temp);
  default:
    return (0);
  }
} // END of chrominance_downsample()

// =======
void CSC_RGB_to_YCC(void) {
  int row, col; // indices for row and column
  static int lut_ready = 0;

  if (RGB_to_YCC_ROUTINE == 4) {
    CSC_RGB_to_YCC_neon_tiled();
    return;
  }

  if (RGB_to_YCC_ROUTINE == 6) {
    CSC_RGB_to_YCC_neon_v2();
    return;
  }

  if (RGB_to_YCC_ROUTINE == 5 && !lut_ready) {
    lut_init();
    lut_ready = 1;
  }

  for (row = 0; row < IMAGE_ROW_SIZE; row += 2) {
    for (col = 0; col < IMAGE_COL_SIZE; col += 2) {
      switch (RGB_to_YCC_ROUTINE) {
      case 0:
        break;
      case 1:
        CSC_RGB_to_YCC_brute_force_float(row, col);
        break;
      case 2:
        CSC_RGB_to_YCC_brute_force_int(row, col);
        break;
      case 3:
        CSC_RGB_to_YCC_neon(row, col);
        break;
      case 5:
        CSC_RGB_to_YCC_lut(row, col);
        break;
default:
        break;
      }
    }
  }

} // END of CSC_RGB_to_YCC()
