// Test harness for YCC-to-RGB: load a viewable image, round-trip through
// RGB->YCC->RGB, and write PPM output you can open in Preview or a browser.

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define GLOBAL
#include "CSC_global.h"

#define DEFAULT_INPUT  "testimages/input.ppm"
#define DEFAULT_OUTPUT "testimages/output.ppm"

static int ends_with( const char *path, const char *suffix) {
  size_t path_len = strlen( path);
  size_t suffix_len = strlen( suffix);
  if( path_len < suffix_len) {
    return 0;
  }
  return strcmp( path + path_len - suffix_len, suffix) == 0;
}

static int load_interleaved_rgb( FILE *fp) {
  int row, col;
  int byte;

  for( row=0; row < IMAGE_ROW_SIZE; row++) {
    for( col=0; col < IMAGE_COL_SIZE; col++) {
      byte = fgetc( fp);
      if( byte == EOF) {
        fprintf( stderr, "Unexpected end of file while reading red.\n");
        return 1;
      }
      R[row][col] = (uint8_t)byte;

      byte = fgetc( fp);
      if( byte == EOF) {
        fprintf( stderr, "Unexpected end of file while reading green.\n");
        return 1;
      }
      G[row][col] = (uint8_t)byte;

      byte = fgetc( fp);
      if( byte == EOF) {
        fprintf( stderr, "Unexpected end of file while reading blue.\n");
        return 1;
      }
      B[row][col] = (uint8_t)byte;
    }
  }

  return 0;
}

static int load_ppm( const char *path) {
  FILE *fp;
  char magic[3];
  int width, height, maxval;
  int row, col;
  int byte;

  fp = fopen( path, "rb");
  if( fp == NULL) {
    fprintf( stderr, "Cannot open %s\n", path);
    return 1;
  }

  if( fscanf( fp, "%2s", magic) != 1 || strcmp( magic, "P6") != 0) {
    fprintf( stderr, "%s: expected binary PPM (P6)\n", path);
    fclose( fp);
    return 1;
  }

  if( fscanf( fp, "%d %d %d", &width, &height, &maxval) != 3) {
    fprintf( stderr, "%s: invalid PPM header\n", path);
    fclose( fp);
    return 1;
  }

  fgetc( fp); // consume single whitespace byte after maxval

  if( width != IMAGE_COL_SIZE || height != IMAGE_ROW_SIZE) {
    fprintf( stderr,
             "%s: image is %dx%d, expected %dx%d (cols x rows)\n",
             path, width, height, IMAGE_COL_SIZE, IMAGE_ROW_SIZE);
    fclose( fp);
    return 1;
  }

  if( maxval != 255) {
    fprintf( stderr, "%s: only 8-bit PPM (maxval 255) is supported\n", path);
    fclose( fp);
    return 1;
  }

  for( row=0; row < IMAGE_ROW_SIZE; row++) {
    for( col=0; col < IMAGE_COL_SIZE; col++) {
      byte = fgetc( fp);
      if( byte == EOF) {
        fprintf( stderr, "%s: truncated pixel data\n", path);
        fclose( fp);
        return 1;
      }
      R[row][col] = (uint8_t)byte;

      byte = fgetc( fp);
      if( byte == EOF) {
        fprintf( stderr, "%s: truncated pixel data\n", path);
        fclose( fp);
        return 1;
      }
      G[row][col] = (uint8_t)byte;

      byte = fgetc( fp);
      if( byte == EOF) {
        fprintf( stderr, "%s: truncated pixel data\n", path);
        fclose( fp);
        return 1;
      }
      B[row][col] = (uint8_t)byte;
    }
  }

  fclose( fp);
  return 0;
}

static int load_raw_rgb( const char *path) {
  FILE *fp;
  int status;

  fp = fopen( path, "rb");
  if( fp == NULL) {
    fprintf( stderr, "Cannot open %s\n", path);
    return 1;
  }

  status = load_interleaved_rgb( fp);
  fclose( fp);
  return status;
}

static int load_input_image( const char *path) {
  if( ends_with( path, ".ppm")) {
    return load_ppm( path);
  }
  if( ends_with( path, ".raw") || ends_with( path, ".data")) {
    return load_raw_rgb( path);
  }

  fprintf( stderr,
           "Unsupported input format for %s (use .ppm, .raw, or .data)\n",
           path);
  return 1;
}

static int write_ppm( const char *path) {
  FILE *fp;
  int row, col;

  fp = fopen( path, "wb");
  if( fp == NULL) {
    fprintf( stderr, "Cannot open %s for writing\n", path);
    return 1;
  }

  fprintf( fp, "P6\n%d %d\n255\n", IMAGE_COL_SIZE, IMAGE_ROW_SIZE);

  for( row=0; row < IMAGE_ROW_SIZE; row++) {
    for( col=0; col < IMAGE_COL_SIZE; col++) {
      fputc( R[row][col], fp);
      fputc( G[row][col], fp);
      fputc( B[row][col], fp);
    }
  }

  fclose( fp);
  return 0;
}

static void print_usage( const char *program) {
  printf( "Usage: %s [input] [output]\n\n", program);
  printf( "Round-trip test for color space conversion:\n");
  printf( "  1. Load RGB image\n");
  printf( "  2. Convert RGB -> YCC\n");
  printf( "  3. Convert YCC -> RGB\n");
  printf( "  4. Write reconstructed RGB as PPM\n\n");
  printf( "Defaults:\n");
  printf( "  input:  %s\n", DEFAULT_INPUT);
  printf( "  output: %s\n\n", DEFAULT_OUTPUT);
  printf( "Supported input formats:\n");
  printf( "  .ppm   binary PPM (P6), must be %dx%d\n",
          IMAGE_COL_SIZE, IMAGE_ROW_SIZE);
  printf( "  .raw / .data  interleaved RGB bytes, no header\n\n");
  printf( "Open the output .ppm in Preview, a browser, or GIMP.\n");
  printf( "Convert a PNG/JPEG to test size with:\n");
  printf( "  make prepare-test-image IMG=/path/to/photo.png\n");
}

int main( int argc, char *argv[]) {
  const char *input_path = DEFAULT_INPUT;
  const char *output_path = DEFAULT_OUTPUT;
  uint8_t R_orig[IMAGE_ROW_SIZE][IMAGE_COL_SIZE];
  uint8_t G_orig[IMAGE_ROW_SIZE][IMAGE_COL_SIZE];
  uint8_t B_orig[IMAGE_ROW_SIZE][IMAGE_COL_SIZE];
  int row, col;
  long long diff_sum = 0;
  int diff_max = 0;

  if( argc == 2 &&
      (strcmp( argv[1], "-h") == 0 || strcmp( argv[1], "--help") == 0)) {
    print_usage( argv[0]);
    return 0;
  }

  if( argc >= 2) {
    input_path = argv[1];
  }
  if( argc >= 3) {
    output_path = argv[2];
  }
  if( argc > 3) {
    print_usage( argv[0]);
    return 1;
  }

  if( load_input_image( input_path) != 0) {
    return 1;
  }

  for( row=0; row < IMAGE_ROW_SIZE; row++) {
    for( col=0; col < IMAGE_COL_SIZE; col++) {
      R_orig[row][col] = R[row][col];
      G_orig[row][col] = G[row][col];
      B_orig[row][col] = B[row][col];
    }
  }

  CSC_RGB_to_YCC();
  CSC_YCC_to_RGB();

  for( row=0; row < IMAGE_ROW_SIZE; row++) {
    for( col=0; col < IMAGE_COL_SIZE; col++) {
      int dr = (int)R[row][col] - (int)R_orig[row][col];
      int dg = (int)G[row][col] - (int)G_orig[row][col];
      int db = (int)B[row][col] - (int)B_orig[row][col];
      int abs_dr = dr < 0 ? -dr : dr;
      int abs_dg = dg < 0 ? -dg : dg;
      int abs_db = db < 0 ? -db : db;
      int pixel_max = abs_dr;

      if( abs_dg > pixel_max) {
        pixel_max = abs_dg;
      }
      if( abs_db > pixel_max) {
        pixel_max = abs_db;
      }
      if( pixel_max > diff_max) {
        diff_max = pixel_max;
      }
      diff_sum += abs_dr + abs_dg + abs_db;
    }
  }

  if( write_ppm( output_path) != 0) {
    return 1;
  }

  printf( "Input:  %s\n", input_path);
  printf( "Output: %s\n", output_path);
  printf( "Routine: RGB_to_YCC=%d, YCC_to_RGB=%d\n",
          RGB_to_YCC_ROUTINE, YCC_to_RGB_ROUTINE);
  printf( "Chroma: downsample mode %d, upsample mode %d\n",
          CHROMINANCE_DOWNSAMPLING_MODE, CHROMINANCE_UPSAMPLING_MODE);
  printf( "Pixel diff vs input: max channel delta=%d, mean abs delta=%.3f\n",
          diff_max,
          (double)diff_sum / (3.0 * IMAGE_ROW_SIZE * IMAGE_COL_SIZE));

  return 0;
}
