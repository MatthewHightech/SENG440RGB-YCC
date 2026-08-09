#include <stdint.h>

#define K 8 // bitwidth
#define UNITY (1 << K)

#ifdef IMAGE_SIZE_LARGE
  #ifndef IMAGE_ROW_SIZE
  #define IMAGE_ROW_SIZE 640
  #endif
  #ifndef IMAGE_COL_SIZE
  #define IMAGE_COL_SIZE 480
  #endif
  #define IMAGE_ID "640_480_02"
#else
  #ifndef IMAGE_ROW_SIZE
  #define IMAGE_ROW_SIZE 64
  #endif
  #ifndef IMAGE_COL_SIZE
  #define IMAGE_COL_SIZE 48
  #endif
  #define IMAGE_ID "64_48_03"
#endif

#ifndef TILE_SIZE
#define TILE_SIZE 16
#endif

// RGB_to_YCC_ROUTINE
//     1 for CSC_RGB_to_YCC_brute_force_float()
//     2 for CSC_RGB_to_YCC_brute_force_int()
//     3 for CSC_RGB_to_YCC_neon()
//     4 for CSC_RGB_to_YCC_neon_tiled()
//     5 for CSC_RGB_to_YCC_lut()
//     6 for CSC_RGB_to_YCC_neon_v2()
#ifndef RGB_to_YCC_ROUTINE
#define RGB_to_YCC_ROUTINE 5
#endif

// YCC_to_RGB_ROUTINE
//     1 for CSC_YCC_to_RGB_brute_force_float()
//     2 for CSC_YCC_to_RGB_brute_force_int()
//     3 for CSC_YCC_to_RGB_neon_v2() -- ARM-only, overflows (see .c)
//     4 for CSC_YCC_to_RGB_neon_v3() -- ARM-only, fixed version
#ifndef YCC_to_RGB_ROUTINE
#define YCC_to_RGB_ROUTINE 2
#endif

// CHROMINANCE_DOWNSAMPLING_MODE =
//     0 for returning zero (no chrominance)
//     1 for discarding three pixels and keeping one
//     2 for averaging four pixels
#ifndef CHROMINANCE_DOWNSAMPLING_MODE
#define CHROMINANCE_DOWNSAMPLING_MODE 2
#endif

// CHROMINANCE_UPSAMPLING_MODE =
//     0 for returning zero (no chrominance)
//     1 for replicating one pixel into three
//     2 for interpolation with two pixels
#ifndef CHROMINANCE_UPSAMPLING_MODE
#define CHROMINANCE_UPSAMPLING_MODE 2
#endif

// RGB-to-YCC coefficients in 8-bit representation
#define C11  66
#define C12 129
#define C13  25
#define C21  38
#define C22  74
#define C23 112
#define C31 112
#define C32  94
#define C33  18

// YCC-to-RGB coefficients in 8-bit representation (scaled by 2^K)
#define D1 298
#define D2 409
#define D3 208
#define D4 100
#define D5 517

/* choose between definition (GLOBAL is defined)      *
 * and declaration (GLOBAL is undefined)              *
 * GLOBAL is defined in exactly one file CSC_main.c)  */

#ifndef GLOBAL
#define EXTERN extern
#else
#define EXTERN
#endif

/* prototypes of global functions */
void CSC_RGB_to_YCC( void);
void CSC_YCC_to_RGB( void);

/* global variables */
EXTERN uint8_t R[IMAGE_ROW_SIZE][IMAGE_COL_SIZE]; // Red array pointer
EXTERN uint8_t G[IMAGE_ROW_SIZE][IMAGE_COL_SIZE]; // Green array pointer
EXTERN uint8_t B[IMAGE_ROW_SIZE][IMAGE_COL_SIZE]; // Blue array pointer
EXTERN uint8_t Y[IMAGE_ROW_SIZE][IMAGE_COL_SIZE]; // Luminance array pointer
EXTERN uint8_t Cb[IMAGE_ROW_SIZE >> 1][IMAGE_COL_SIZE >> 1]; // Chrominance (Cb) array pointer
EXTERN uint8_t Cr[IMAGE_ROW_SIZE >> 1][IMAGE_COL_SIZE >> 1]; // Chrominance (Cr) array pointer
EXTERN uint8_t Cb_temp[IMAGE_ROW_SIZE][IMAGE_COL_SIZE]; // Chrominance (Cb) temp array pointer
EXTERN uint8_t Cr_temp[IMAGE_ROW_SIZE][IMAGE_COL_SIZE]; // Chrominance (Cr) temp array pointer
