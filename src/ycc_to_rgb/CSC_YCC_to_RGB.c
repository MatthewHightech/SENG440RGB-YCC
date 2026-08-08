// Copyright 2023 Mihai SIMA (mihai.sima@ieee.org).  All rights reserved.
// Color Space Conversion (CSC) in fixed-point arithmetic
// YCC to RGB conversion

//#include <stdio.h>
#include <stdint.h>
#include "CSC_global.h"

// NEON intrinsics are ARM-only; guard so `make native` (host x86, used for
// the round-trip test/bench harness) keeps building float/int routines.
#if defined(__aarch64__) || defined(__arm__)
#define CSC_HAVE_NEON 1
#include <arm_neon.h>
#endif

// private data

// private prototypes
// =======
static uint8_t saturation_float( float argument);
static void CSC_YCC_to_RGB_brute_force_float( int row, int col);

// =======
static uint8_t saturation_int( int argument);
static void CSC_YCC_to_RGB_brute_force_int( int row, int col);

#ifdef CSC_HAVE_NEON
// =======
static void CSC_YCC_to_RGB_neon_v2( void);

// =======
static void CSC_YCC_to_RGB_neon_v3( void);
#endif

// =======
static void chrominance_upsample(
    uint8_t C_pixel_1, uint8_t C_pixel_2,
    uint8_t C_pixel_3, uint8_t C_pixel_4,
    uint8_t *top, uint8_t *left, uint8_t *middle);
// =======
static void chrominance_array_upsample( void);

// private definitions
// =======
static uint8_t saturation_float( float argument) {
  if( argument > 255.0) { // saturation
    return( (uint8_t)255);
  }
  else if( argument < 0.0) {
    return( (uint8_t)0);
  }
  else {
    return( (uint8_t)argument);
  }
} // END of saturation_float()

// =======
static void CSC_YCC_to_RGB_brute_force_float( int row, int col) {
//
  float R_pixel_00, R_pixel_01, R_pixel_10, R_pixel_11;
  float G_pixel_00, G_pixel_01, G_pixel_10, G_pixel_11;
  float B_pixel_00, B_pixel_01, B_pixel_10, B_pixel_11;

  // Cb_temp / Cr_temp must already be filled by chrominance_array_upsample()

  R_pixel_00 =   1.164*(Y[row+0][col+0] - 16.0)
               + 1.596*(Cr_temp[row+0][col+0] - 128.0);
  R[row+0][col+0] = saturation_float( R_pixel_00);
//
  R_pixel_01 =   1.164*(Y[row+0][col+1] - 16.0)
               + 1.596*(Cr_temp[row+0][col+1] - 128.0);
  R[row+0][col+1] = saturation_float( R_pixel_01);
//
  R_pixel_10 =   1.164*(Y[row+1][col+0] - 16.0)
               + 1.596*(Cr_temp[row+1][col+0] - 128.0);
  R[row+1][col+0] = saturation_float( R_pixel_10);
//
  R_pixel_11 =   1.164*(Y[row+1][col+1] - 16.0)
               + 1.596*(Cr_temp[row+1][col+1] - 128.0);
  R[row+1][col+1] = saturation_float( R_pixel_11);

  G_pixel_00 =   1.164*(Y[row+0][col+0] - 16.0)
               - 0.813*(Cr_temp[row+0][col+0] - 128.0)
               - 0.391*(Cb_temp[row+0][col+0] - 128.0);
  G[row+0][col+0] = saturation_float( G_pixel_00);
//
  G_pixel_01 =   1.164*(Y[row+0][col+1] - 16.0)
               - 0.813*(Cr_temp[row+0][col+1] - 128.0)
               - 0.391*(Cb_temp[row+0][col+1] - 128.0);
  G[row+0][col+1] = saturation_float( G_pixel_01);
//
  G_pixel_10 =   1.164*(Y[row+1][col+0] - 16.0)
               - 0.813*(Cr_temp[row+1][col+0] - 128.0)
               - 0.391*(Cb_temp[row+1][col+0] - 128.0);
  G[row+1][col+0] = saturation_float( G_pixel_10);
//
  G_pixel_11 =   1.164*(Y[row+1][col+1] - 16.0)
               - 0.813*(Cr_temp[row+1][col+1] - 128.0)
               - 0.391*(Cb_temp[row+1][col+1] - 128.0);
  G[row+1][col+1] = saturation_float( G_pixel_11);

  B_pixel_00 =   1.164*(Y[row+0][col+0] - 16.0)
               + 2.018*(Cb_temp[row+0][col+0] - 128.0);
  B[row+0][col+0] = saturation_float( B_pixel_00);
//
  B_pixel_01 =   1.164*(Y[row+0][col+1] - 16.0)
               + 2.018*(Cb_temp[row+0][col+1] - 128.0);
  B[row+0][col+1] = saturation_float( B_pixel_01);
//
  B_pixel_10 =   1.164*(Y[row+1][col+0] - 16.0)
               + 2.018*(Cb_temp[row+1][col+0] - 128.0);
  B[row+1][col+0] = saturation_float( B_pixel_10);
//
  B_pixel_11 =   1.164*(Y[row+1][col+1] - 16.0)
               + 2.018*(Cb_temp[row+1][col+1] - 128.0);
  B[row+1][col+1] = saturation_float( B_pixel_11);
} // END of CSC_YCC_to_RGB_brute_force_float()

// =======
static uint8_t saturation_int( int argument) {
  if( argument > 255) { // saturation
    return( (uint8_t)255);
  }
  else if( argument < 0) {
    return( (uint8_t)0);
  }
  else {
    return( (uint8_t)argument);
  }
} // END of saturation_int()

// =======
static void CSC_YCC_to_RGB_brute_force_int( int row, int col) {
//
  int R_pixel_00, R_pixel_01, R_pixel_10, R_pixel_11;
  int G_pixel_00, G_pixel_01, G_pixel_10, G_pixel_11;
  int B_pixel_00, B_pixel_01, B_pixel_10, B_pixel_11;

  int  Y_pixel_00,  Y_pixel_01,  Y_pixel_10,  Y_pixel_11;
  int Cb_pixel_00, Cb_pixel_01, Cb_pixel_10, Cb_pixel_11;
  int Cr_pixel_00, Cr_pixel_01, Cr_pixel_10, Cr_pixel_11;

  // Cb_temp / Cr_temp must already be filled by chrominance_array_upsample()

  Y_pixel_00 = (int)Y[row+0][col+0];
  Y_pixel_01 = (int)Y[row+0][col+1];
  Y_pixel_10 = (int)Y[row+1][col+0];
  Y_pixel_11 = (int)Y[row+1][col+1];

  Cb_pixel_00 = (int)Cb_temp[row+0][col+0];
  Cb_pixel_01 = (int)Cb_temp[row+0][col+1];
  Cb_pixel_10 = (int)Cb_temp[row+1][col+0];
  Cb_pixel_11 = (int)Cb_temp[row+1][col+1];

  Cr_pixel_00 = (int)Cr_temp[row+0][col+0];
  Cr_pixel_01 = (int)Cr_temp[row+0][col+1];
  Cr_pixel_10 = (int)Cr_temp[row+1][col+0];
  Cr_pixel_11 = (int)Cr_temp[row+1][col+1];

  Y_pixel_00 = Y_pixel_00 - 16;
  Y_pixel_01 = Y_pixel_01 - 16;
  Y_pixel_10 = Y_pixel_10 - 16;
  Y_pixel_11 = Y_pixel_11 - 16;

  Cb_pixel_00 = Cb_pixel_00 - 128;
  Cb_pixel_01 = Cb_pixel_01 - 128;
  Cb_pixel_10 = Cb_pixel_10 - 128;
  Cb_pixel_11 = Cb_pixel_11 - 128;

  Cr_pixel_00 = Cr_pixel_00 - 128;
  Cr_pixel_01 = Cr_pixel_01 - 128;
  Cr_pixel_10 = Cr_pixel_10 - 128;
  Cr_pixel_11 = Cr_pixel_11 - 128;

  R_pixel_00 = D1 * Y_pixel_00 + D2 * Cr_pixel_00;
  R_pixel_00 += (1 << (K-1)); // rounding
  R_pixel_00 = R_pixel_00 >> K;

  R_pixel_01 = D1 * Y_pixel_01 + D2 * Cr_pixel_01;
  R_pixel_01 += (1 << (K-1)); // rounding
  R_pixel_01 = R_pixel_01 >> K;

  R_pixel_10 = D1 * Y_pixel_10 + D2 * Cr_pixel_10;
  R_pixel_10 += (1 << (K-1)); // rounding
  R_pixel_10 = R_pixel_10 >> K;

  R_pixel_11 = D1 * Y_pixel_11 + D2 * Cr_pixel_11;
  R_pixel_11 += (1 << (K-1)); // rounding
  R_pixel_11 = R_pixel_11 >> K;

  R[row+0][col+0] = saturation_int( R_pixel_00);
  R[row+0][col+1] = saturation_int( R_pixel_01);
  R[row+1][col+0] = saturation_int( R_pixel_10);
  R[row+1][col+1] = saturation_int( R_pixel_11);

  G_pixel_00 = D1 * Y_pixel_00 - D3 * Cr_pixel_00
                               - D4 * Cb_pixel_00;
  G_pixel_00 += (1 << (K-1)); // rounding
  G_pixel_00 = G_pixel_00 >> K;

  G_pixel_01 = D1 * Y_pixel_01 - D3 * Cr_pixel_01
                               - D4 * Cb_pixel_01;
  G_pixel_01 += (1 << (K-1)); // rounding
  G_pixel_01 = G_pixel_01 >> K;

  G_pixel_10 = D1 * Y_pixel_10 - D3 * Cr_pixel_10
                               - D4 * Cb_pixel_10;
  G_pixel_10 += (1 << (K-1)); // rounding
  G_pixel_10 = G_pixel_10 >> K;

  G_pixel_11 = D1 * Y_pixel_11 - D3 * Cr_pixel_11
                               - D4 * Cb_pixel_11;
  G_pixel_11 += (1 << (K-1)); // rounding
  G_pixel_11 = G_pixel_11 >> K;

  G[row+0][col+0] = saturation_int( G_pixel_00);
  G[row+0][col+1] = saturation_int( G_pixel_01);
  G[row+1][col+0] = saturation_int( G_pixel_10);
  G[row+1][col+1] = saturation_int( G_pixel_11);

  B_pixel_00 = D1 * Y_pixel_00 + D5 * Cb_pixel_00;
  B_pixel_00 += (1 << (K-1)); // rounding
  B_pixel_00 = B_pixel_00 >> K;

  B_pixel_01 = D1 * Y_pixel_01 + D5 * Cb_pixel_01;
  B_pixel_01 += (1 << (K-1)); // rounding
  B_pixel_01 = B_pixel_01 >> K;

  B_pixel_10 = D1 * Y_pixel_10 + D5 * Cb_pixel_10;
  B_pixel_10 += (1 << (K-1)); // rounding
  B_pixel_10 = B_pixel_10 >> K;

  B_pixel_11 = D1 * Y_pixel_11 + D5 * Cb_pixel_11;
  B_pixel_11 += (1 << (K-1)); // rounding
  B_pixel_11 = B_pixel_11 >> K;

  B[row+0][col+0] = saturation_int( B_pixel_00);
  B[row+0][col+1] = saturation_int( B_pixel_01);
  B[row+1][col+0] = saturation_int( B_pixel_10);
  B[row+1][col+1] = saturation_int( B_pixel_11);

} // END of CSC_YCC_to_RGB_brute_force_int()

#ifdef CSC_HAVE_NEON
// =======
// Ported RGB->YCC's neon_v2 (uint16x8_t, vld1_u8+vmovl_u8) straight over,
// figured the same lane width would just work. It doesn't -- D1*(Y-16) +
// D2*(Cr-128) hits ~123,165 worst case, past int16_t/uint16_t range.
// neon_v3 below is the fix; keeping this one as the overflow example.
//
// Cb_temp / Cr_temp must already be filled by chrominance_array_upsample().
static void CSC_YCC_to_RGB_neon_v2( void) {
  int row, col;
  for( row = 0; row < IMAGE_ROW_SIZE; row += 1) {
    for( col = 0; col < IMAGE_COL_SIZE; col += 8) {

      uint8x8_t y8  = vld1_u8( &Y[row][col]);
      uint8x8_t cb8 = vld1_u8( &Cb_temp[row][col]);
      uint8x8_t cr8 = vld1_u8( &Cr_temp[row][col]);

      int16x8_t y_s  = vreinterpretq_s16_u16( vmovl_u8( y8));
      int16x8_t cb_s = vreinterpretq_s16_u16( vmovl_u8( cb8));
      int16x8_t cr_s = vreinterpretq_s16_u16( vmovl_u8( cr8));

      y_s  = vsubq_s16( y_s,  vdupq_n_s16( 16));
      cb_s = vsubq_s16( cb_s, vdupq_n_s16( 128));
      cr_s = vsubq_s16( cr_s, vdupq_n_s16( 128));

      // R = D1*(Y-16) + D2*(Cr-128)
      int16x8_t r_vec = vdupq_n_s16( 1 << (K - 1));
      r_vec = vmlaq_n_s16( r_vec, y_s, D1);
      r_vec = vmlaq_n_s16( r_vec, cr_s, D2);
      r_vec = vshrq_n_s16( r_vec, K);

      // G = D1*(Y-16) - D3*(Cr-128) - D4*(Cb-128)
      int16x8_t g_vec = vdupq_n_s16( 1 << (K - 1));
      g_vec = vmlaq_n_s16( g_vec, y_s, D1);
      g_vec = vmlsq_n_s16( g_vec, cr_s, D3);
      g_vec = vmlsq_n_s16( g_vec, cb_s, D4);
      g_vec = vshrq_n_s16( g_vec, K);

      // B = D1*(Y-16) + D5*(Cb-128)
      int16x8_t b_vec = vdupq_n_s16( 1 << (K - 1));
      b_vec = vmlaq_n_s16( b_vec, y_s, D1);
      b_vec = vmlaq_n_s16( b_vec, cb_s, D5);
      b_vec = vshrq_n_s16( b_vec, K);

      vst1_u8( &R[row][col], vqmovun_s16( r_vec));
      vst1_u8( &G[row][col], vqmovun_s16( g_vec));
      vst1_u8( &B[row][col], vqmovun_s16( b_vec));
    }
  }
} // END of CSC_YCC_to_RGB_neon_v2()

// =======
// Same load/widen as neon_v2, but the multiply-accumulate runs in
// int32x4_t instead of int16_t -- split each 8-lane value into low/high
// halves so it's still 4-wide per instruction, just fed by 8-wide loads.
//
// Cb_temp / Cr_temp must already be filled by chrominance_array_upsample().
static void CSC_YCC_to_RGB_neon_v3( void) {
  int row, col;
  for( row = 0; row < IMAGE_ROW_SIZE; row += 1) {
    for( col = 0; col < IMAGE_COL_SIZE; col += 8) {

      uint8x8_t y8  = vld1_u8( &Y[row][col]);
      uint8x8_t cb8 = vld1_u8( &Cb_temp[row][col]);
      uint8x8_t cr8 = vld1_u8( &Cr_temp[row][col]);

      int16x8_t y_s  = vreinterpretq_s16_u16( vmovl_u8( y8));
      int16x8_t cb_s = vreinterpretq_s16_u16( vmovl_u8( cb8));
      int16x8_t cr_s = vreinterpretq_s16_u16( vmovl_u8( cr8));

      y_s  = vsubq_s16( y_s,  vdupq_n_s16( 16));
      cb_s = vsubq_s16( cb_s, vdupq_n_s16( 128));
      cr_s = vsubq_s16( cr_s, vdupq_n_s16( 128));

      int32x4_t y_lo  = vmovl_s16( vget_low_s16( y_s));
      int32x4_t y_hi  = vmovl_s16( vget_high_s16( y_s));
      int32x4_t cb_lo = vmovl_s16( vget_low_s16( cb_s));
      int32x4_t cb_hi = vmovl_s16( vget_high_s16( cb_s));
      int32x4_t cr_lo = vmovl_s16( vget_low_s16( cr_s));
      int32x4_t cr_hi = vmovl_s16( vget_high_s16( cr_s));

      // R = D1*(Y-16) + D2*(Cr-128)
      int32x4_t r_lo = vdupq_n_s32( 1 << (K - 1));
      r_lo = vmlaq_n_s32( r_lo, y_lo, D1);
      r_lo = vmlaq_n_s32( r_lo, cr_lo, D2);
      r_lo = vshrq_n_s32( r_lo, K);
      int32x4_t r_hi = vdupq_n_s32( 1 << (K - 1));
      r_hi = vmlaq_n_s32( r_hi, y_hi, D1);
      r_hi = vmlaq_n_s32( r_hi, cr_hi, D2);
      r_hi = vshrq_n_s32( r_hi, K);

      // G = D1*(Y-16) - D3*(Cr-128) - D4*(Cb-128)
      int32x4_t g_lo = vdupq_n_s32( 1 << (K - 1));
      g_lo = vmlaq_n_s32( g_lo, y_lo, D1);
      g_lo = vmlsq_n_s32( g_lo, cr_lo, D3);
      g_lo = vmlsq_n_s32( g_lo, cb_lo, D4);
      g_lo = vshrq_n_s32( g_lo, K);
      int32x4_t g_hi = vdupq_n_s32( 1 << (K - 1));
      g_hi = vmlaq_n_s32( g_hi, y_hi, D1);
      g_hi = vmlsq_n_s32( g_hi, cr_hi, D3);
      g_hi = vmlsq_n_s32( g_hi, cb_hi, D4);
      g_hi = vshrq_n_s32( g_hi, K);

      // B = D1*(Y-16) + D5*(Cb-128)
      int32x4_t b_lo = vdupq_n_s32( 1 << (K - 1));
      b_lo = vmlaq_n_s32( b_lo, y_lo, D1);
      b_lo = vmlaq_n_s32( b_lo, cb_lo, D5);
      b_lo = vshrq_n_s32( b_lo, K);
      int32x4_t b_hi = vdupq_n_s32( 1 << (K - 1));
      b_hi = vmlaq_n_s32( b_hi, y_hi, D1);
      b_hi = vmlaq_n_s32( b_hi, cb_hi, D5);
      b_hi = vshrq_n_s32( b_hi, K);

      vst1_u8( &R[row][col], vqmovun_s16( vcombine_s16( vqmovn_s32( r_lo), vqmovn_s32( r_hi))));
      vst1_u8( &G[row][col], vqmovun_s16( vcombine_s16( vqmovn_s32( g_lo), vqmovn_s32( g_hi))));
      vst1_u8( &B[row][col], vqmovun_s16( vcombine_s16( vqmovn_s32( b_lo), vqmovn_s32( b_hi))));
    }
  }
} // END of CSC_YCC_to_RGB_neon_v3()
#endif // CSC_HAVE_NEON

// =======
static void chrominance_upsample(
    uint8_t C_pixel_00, uint8_t C_pixel_01,
    uint8_t C_pixel_10, uint8_t C_pixel_11,
    uint8_t *top, uint8_t *left, uint8_t *middle) {

  int temp_top;
  int temp_left;
  int temp_middle;

  switch (CHROMINANCE_UPSAMPLING_MODE) {
    case 0:
      *top = 0;
      *left = 0;
      *middle = 0;
      break;
    case 1:
      *top = (uint8_t)C_pixel_00;
      *left = (uint8_t)C_pixel_00;
      *middle = (uint8_t)C_pixel_00;
      break;
    case 2:
      temp_top = (int)C_pixel_00 + (int)C_pixel_01;
      temp_top += (1 << 0); // rounding
      *top = (uint8_t)(temp_top >> 1);
//
      temp_left = (int)C_pixel_00 + (int)C_pixel_10;
      temp_left += (1 << 0); // rounding
      *left = (uint8_t)(temp_left >> 1);
//
      temp_middle = (int)C_pixel_00 + (int)C_pixel_01 + 
                    (int)C_pixel_10 + (int)C_pixel_11;
      temp_middle += (1 << 1); // rounding
      *middle = (uint8_t)(temp_middle >> 2);
      break;
    default:
      break;
  }
} // END of chrominance_upsample()

// =======
static void chrominance_array_upsample( void) {
  int row, col;

  uint8_t top;
  uint8_t left;
  uint8_t middle;

  for( row=0; row<((IMAGE_ROW_SIZE>>1)-1); row+=1) {
    for( col=0; col<((IMAGE_COL_SIZE>>1)-1); col+=1) { 
      chrominance_upsample( Cb[row+0][col+0], Cb[row+0][col+1],
                            Cb[row+1][col+0], Cb[row+1][col+1],
                            &top, &left, &middle);
      Cb_temp[(row<<1)+0][(col<<1)+0] = Cb[row+0][col+0];
      Cb_temp[(row<<1)+0][(col<<1)+1] = top;
      Cb_temp[(row<<1)+1][(col<<1)+0] = left;
      Cb_temp[(row<<1)+1][(col<<1)+1] = middle;
      //
      chrominance_upsample( Cr[row+0][col+0], Cr[row+0][col+1],
                            Cr[row+1][col+0], Cr[row+1][col+1],
                            &top, &left, &middle);
      Cr_temp[(row<<1)+0][(col<<1)+0] = Cr[row+0][col+0];
      Cr_temp[(row<<1)+0][(col<<1)+1] = top;
      Cr_temp[(row<<1)+1][(col<<1)+0] = left;
      Cr_temp[(row<<1)+1][(col<<1)+1] = middle;
    }
  }

  col = (IMAGE_COL_SIZE>>1) - 1;
  for( row=0; row<((IMAGE_ROW_SIZE>>1)-1); row+=1) {
    chrominance_upsample( Cb[row+0][col], Cb[row+0][col],
                          Cb[row+1][col], Cb[row+1][col],
                          &top, &left, &middle);
    Cb_temp[(row<<1)+0][(col<<1)+0] = Cb[row+0][col];
    Cb_temp[(row<<1)+0][(col<<1)+1] = top;
    Cb_temp[(row<<1)+1][(col<<1)+0] = left;
    Cb_temp[(row<<1)+1][(col<<1)+1] = middle;
    //
    chrominance_upsample( Cr[row+0][col], Cr[row+0][col],
                          Cr[row+1][col], Cr[row+1][col],
                          &top, &left, &middle);
    Cr_temp[(row<<1)+0][(col<<1)+0] = Cr[row+0][col];
    Cr_temp[(row<<1)+0][(col<<1)+1] = top;
    Cr_temp[(row<<1)+1][(col<<1)+0] = left;
    Cr_temp[(row<<1)+1][(col<<1)+1] = middle;
  }

  row = (IMAGE_ROW_SIZE>>1) - 1;
  for( col=0; col<((IMAGE_COL_SIZE>>1)-1); col+=1) {
    chrominance_upsample( Cb[row][col+0], Cb[row][col+1],
                          Cb[row][col+0], Cb[row][col+1],
                          &top, &left, &middle);
    Cb_temp[(row<<1)+0][(col<<1)+0] = Cb[row][col+0];
    Cb_temp[(row<<1)+0][(col<<1)+1] = top;
    Cb_temp[(row<<1)+1][(col<<1)+0] = left;
    Cb_temp[(row<<1)+1][(col<<1)+1] = middle;
    //
    chrominance_upsample( Cr[row][col+0], Cr[row][col+1],
                          Cr[row][col+0], Cr[row][col+1],
                          &top, &left, &middle);
    Cr_temp[(row<<1)+0][(col<<1)+0] = Cr[row][col+0];
    Cr_temp[(row<<1)+0][(col<<1)+1] = top;
    Cr_temp[(row<<1)+1][(col<<1)+0] = left;
    Cr_temp[(row<<1)+1][(col<<1)+1] = middle;
  }

  row = (IMAGE_ROW_SIZE>>1) - 1;
  col = (IMAGE_COL_SIZE>>1) - 1;
  Cb_temp[(row<<1)+0][(col<<1)+0] = Cb[row][col];
  Cb_temp[(row<<1)+0][(col<<1)+1] = Cb[row][col];
  Cb_temp[(row<<1)+1][(col<<1)+0] = Cb[row][col];
  Cb_temp[(row<<1)+1][(col<<1)+1] = Cb[row][col];
  //
  Cr_temp[(row<<1)+0][(col<<1)+0] = Cr[row][col];
  Cr_temp[(row<<1)+0][(col<<1)+1] = Cr[row][col];
  Cr_temp[(row<<1)+1][(col<<1)+0] = Cr[row][col];
  Cr_temp[(row<<1)+1][(col<<1)+1] = Cr[row][col];

} // END of chrominance_array_upsample()

// =======
void CSC_YCC_to_RGB( void) {
  int row, col; // indices for row and column

  // Expand half-res Cb/Cr once, then convert every 2x2 block (or, for
  // routines 3/4, the whole image in one pass -- see below).
  if( YCC_to_RGB_ROUTINE == 1 || YCC_to_RGB_ROUTINE == 2 ||
      YCC_to_RGB_ROUTINE == 3 || YCC_to_RGB_ROUTINE == 4) {
    chrominance_array_upsample();
  }

#ifdef CSC_HAVE_NEON
  if( YCC_to_RGB_ROUTINE == 3) {
    CSC_YCC_to_RGB_neon_v2();
    return;
  }
  if( YCC_to_RGB_ROUTINE == 4) {
    CSC_YCC_to_RGB_neon_v3();
    return;
  }
#endif

  for( row=0; row<IMAGE_ROW_SIZE; row+=2) {
    for( col=0; col<IMAGE_COL_SIZE; col+=2) {
      //printf( "\n[row,col] = [%02i,%02i]\n\n", row, col);
      switch (YCC_to_RGB_ROUTINE) {
        case 0:
          break;
        case 1:
          CSC_YCC_to_RGB_brute_force_float( row, col);
          break;
        case 2:
          CSC_YCC_to_RGB_brute_force_int( row, col);
          break;
        default:
          break;
      }
//      printf( "Luma_00  = %02hhx\n", Y[row+0][col+0]);
//      printf( "Luma_01  = %02hhx\n", Y[row+0][col+1]);
//      printf( "Luma_10  = %02hhx\n", Y[row+1][col+0]);
//      printf( "Luma_11  = %02hhx\n\n", Y[row+1][col+1]);
    }
  }

} // END of CSC_YCC_to_RGB()

