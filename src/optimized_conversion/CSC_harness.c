#include "CSC_harness.h"

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>

uint64_t csc_now_ns( void) {
  struct timespec ts;

  if( clock_gettime( CLOCK_MONOTONIC, &ts) != 0) {
    return 0;
  }
  return (uint64_t)ts.tv_sec * 1000000000ull + (uint64_t)ts.tv_nsec;
}

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

int csc_load_input_image( const char *path) {
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

int csc_write_ppm( const char *path) {
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

void csc_snapshot_rgb(
    uint8_t R_dst[IMAGE_ROW_SIZE][IMAGE_COL_SIZE],
    uint8_t G_dst[IMAGE_ROW_SIZE][IMAGE_COL_SIZE],
    uint8_t B_dst[IMAGE_ROW_SIZE][IMAGE_COL_SIZE]) {
  memcpy( R_dst, R, sizeof( R[0][0]) * IMAGE_ROW_SIZE * IMAGE_COL_SIZE);
  memcpy( G_dst, G, sizeof( G[0][0]) * IMAGE_ROW_SIZE * IMAGE_COL_SIZE);
  memcpy( B_dst, B, sizeof( B[0][0]) * IMAGE_ROW_SIZE * IMAGE_COL_SIZE);
}

void csc_restore_rgb(
    const uint8_t R_src[IMAGE_ROW_SIZE][IMAGE_COL_SIZE],
    const uint8_t G_src[IMAGE_ROW_SIZE][IMAGE_COL_SIZE],
    const uint8_t B_src[IMAGE_ROW_SIZE][IMAGE_COL_SIZE]) {
  memcpy( R, R_src, sizeof( R[0][0]) * IMAGE_ROW_SIZE * IMAGE_COL_SIZE);
  memcpy( G, G_src, sizeof( G[0][0]) * IMAGE_ROW_SIZE * IMAGE_COL_SIZE);
  memcpy( B, B_src, sizeof( B[0][0]) * IMAGE_ROW_SIZE * IMAGE_COL_SIZE);
}

void csc_compute_quality(
    const uint8_t R_orig[IMAGE_ROW_SIZE][IMAGE_COL_SIZE],
    const uint8_t G_orig[IMAGE_ROW_SIZE][IMAGE_COL_SIZE],
    const uint8_t B_orig[IMAGE_ROW_SIZE][IMAGE_COL_SIZE],
    int *diff_max_out,
    double *mean_abs_delta_out) {
  int row, col;
  long long diff_sum = 0;
  int diff_max = 0;

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

  *diff_max_out = diff_max;
  *mean_abs_delta_out =
      (double)diff_sum / (3.0 * IMAGE_ROW_SIZE * IMAGE_COL_SIZE);
}

static int ensure_parent_dir( const char *path) {
  char dir[512];
  size_t len;
  char *slash;

  len = strlen( path);
  if( len >= sizeof( dir)) {
    return 1;
  }
  memcpy( dir, path, len + 1);
  slash = strrchr( dir, '/');
  if( slash == NULL) {
    return 0;
  }
  *slash = '\0';
  if( dir[0] == '\0') {
    return 0;
  }
  if( mkdir( dir, 0755) == 0 || errno == EEXIST) {
    return 0;
  }
  return 1;
}

static int append_walltime_csv(
    const char *path,
    const CSC_RunConfig *cfg,
    const CSC_WallMetrics *m) {
  FILE *fp;
  time_t now;
  struct tm tm_now;
  char timestamp[32];
  long pos;

  if( ensure_parent_dir( path) != 0) {
    fprintf( stderr, "Cannot create directory for %s\n", path);
    return 1;
  }

  fp = fopen( path, "a");
  if( fp == NULL) {
    fprintf( stderr, "Cannot open wall-time metrics file %s\n", path);
    return 1;
  }

  pos = ftell( fp);
  if( pos <= 0) {
    fprintf( fp,
             "timestamp,label,input,rows,cols,"
             "rgb_to_ycc_routine,ycc_to_rgb_routine,"
             "downsample_mode,upsample_mode,iterations,"
             "rgb_to_ycc_ms_mean,ycc_to_rgb_ms_mean,ycc_to_rgb_ms_min,"
             "total_ms_mean,mpix_per_s,ns_per_pixel,"
             "diff_max,mean_abs_delta\n");
  }

  now = time( NULL);
  localtime_r( &now, &tm_now);
  strftime( timestamp, sizeof( timestamp), "%Y-%m-%dT%H:%M:%S", &tm_now);

  fprintf( fp,
           "%s,%s,%s,%d,%d,%d,%d,%d,%d,%d,"
           "%.6f,%.6f,%.6f,%.6f,%.6f,%.3f,%d,%.6f\n",
           timestamp,
           cfg->label ? cfg->label : "",
           cfg->input_path ? cfg->input_path : "",
           IMAGE_ROW_SIZE,
           IMAGE_COL_SIZE,
           RGB_to_YCC_ROUTINE,
           YCC_to_RGB_ROUTINE,
           CHROMINANCE_DOWNSAMPLING_MODE,
           CHROMINANCE_UPSAMPLING_MODE,
           cfg->iterations,
           m->rgb_to_ycc_ms_mean,
           m->ycc_to_rgb_ms_mean,
           m->ycc_to_rgb_ms_min,
           m->total_ms_mean,
           m->mpix_per_s,
           m->ns_per_pixel,
           m->diff_max,
           m->mean_abs_delta);

  fclose( fp);
  return 0;
}

void csc_fill_wall_metrics(
    int iterations,
    uint64_t rgb_ns_sum,
    uint64_t ycc_ns_sum,
    uint64_t ycc_ns_min,
    int diff_max,
    double mean_abs_delta,
    CSC_WallMetrics *out) {
  double pixels = (double)IMAGE_ROW_SIZE * (double)IMAGE_COL_SIZE;

  out->rgb_to_ycc_ms_mean =
      ((double)rgb_ns_sum / (double)iterations) / 1.0e6;
  out->ycc_to_rgb_ms_mean =
      ((double)ycc_ns_sum / (double)iterations) / 1.0e6;
  out->ycc_to_rgb_ms_min = (double)ycc_ns_min / 1.0e6;
  out->total_ms_mean = out->rgb_to_ycc_ms_mean + out->ycc_to_rgb_ms_mean;
  out->ns_per_pixel =
      ((double)ycc_ns_sum / (double)iterations) / pixels;
  out->mpix_per_s =
      (pixels / 1.0e6) / (out->ycc_to_rgb_ms_mean / 1000.0);
  out->diff_max = diff_max;
  out->mean_abs_delta = mean_abs_delta;
}

void csc_print_wall_metrics(
    const CSC_RunConfig *cfg,
    const CSC_WallMetrics *m) {
  printf( "Input:  %s\n", cfg->input_path);
  printf( "Output: %s\n", cfg->output_path);
  printf( "\n=== Wall-time Metrics (secondary) ===\n");
  printf( "Label:              %s\n", cfg->label);
  printf( "Config:             RGB->YCC=%d  YCC->RGB=%d  "
          "downsample=%d  upsample=%d\n",
          RGB_to_YCC_ROUTINE, YCC_to_RGB_ROUTINE,
          CHROMINANCE_DOWNSAMPLING_MODE, CHROMINANCE_UPSAMPLING_MODE);
  printf( "Iterations:         %d (after 1 warmup)\n", cfg->iterations);
  printf( "RGB->YCC mean:      %.6f ms\n", m->rgb_to_ycc_ms_mean);
  printf( "YCC->RGB mean:      %.6f ms\n", m->ycc_to_rgb_ms_mean);
  printf( "YCC->RGB min:       %.6f ms\n", m->ycc_to_rgb_ms_min);
  printf( "Total convert mean: %.6f ms\n", m->total_ms_mean);
  printf( "YCC->RGB throughput:%.3f Mpix/s  (%.1f ns/pixel)\n",
          m->mpix_per_s, m->ns_per_pixel);
  printf( "Quality:            max channel delta=%d  mean abs delta=%.3f\n",
          m->diff_max, m->mean_abs_delta);
}

int csc_report_wall_metrics(
    const CSC_RunConfig *cfg,
    const CSC_WallMetrics *m) {
  csc_print_wall_metrics( cfg, m);

  if( strcmp( cfg->metrics_path, "/dev/null") == 0 ||
      strcmp( cfg->metrics_path, "NUL") == 0) {
    printf( "Wall-time CSV skipped (%s)\n", cfg->metrics_path);
    return 0;
  }

  if( append_walltime_csv( cfg->metrics_path, cfg, m) != 0) {
    return 1;
  }
  printf( "Wall-time metrics appended to %s\n", cfg->metrics_path);
  return 0;
}

void csc_print_usage( const char *program) {
  printf( "Usage: %s [input] [output] [options]\n\n", program);
  printf( "Round-trip CSC test with secondary wall-time metrics:\n");
  printf( "  1. Load RGB image\n");
  printf( "  2. Warmup + timed RGB->YCC / YCC->RGB (CLOCK_MONOTONIC)\n");
  printf( "  3. Write reconstructed RGB as PPM\n");
  printf( "  4. Append wall-time row to CSV\n\n");
  printf( "Defaults:\n");
  printf( "  input:   %s\n", CSC_DEFAULT_INPUT);
  printf( "  output:  %s\n", CSC_DEFAULT_OUTPUT);
  printf( "  iters:   %d\n", CSC_DEFAULT_ITERS);
  printf( "  metrics: %s\n\n", CSC_DEFAULT_WALL_CSV);
  printf( "Options:\n");
  printf( "  --iters N       Timed iterations after 1 warmup (default %d)\n",
          CSC_DEFAULT_ITERS);
  printf( "  --label NAME    Tag this run in the CSV\n");
  printf( "  --metrics PATH  Wall-time CSV path (default %s)\n",
          CSC_DEFAULT_WALL_CSV);
  printf( "  -h, --help      Show this help\n\n");
  printf( "For Cachegrind (primary Ir/miss metrics), use:\n");
  printf( "  make cachegrind LABEL=...\n");
  printf( "  make measure LABEL=...   # wall-time first, then Cachegrind\n");
}

int csc_parse_args( int argc, char *argv[], CSC_RunConfig *cfg) {
  int i;
  int positional = 0;

  cfg->input_path = CSC_DEFAULT_INPUT;
  cfg->output_path = CSC_DEFAULT_OUTPUT;
  cfg->metrics_path = CSC_DEFAULT_WALL_CSV;
  cfg->label = "baseline";
  cfg->iterations = CSC_DEFAULT_ITERS;
  cfg->show_help = 0;

  for( i=1; i < argc; i++) {
    if( strcmp( argv[i], "-h") == 0 || strcmp( argv[i], "--help") == 0) {
      cfg->show_help = 1;
      return 0;
    }
    if( strcmp( argv[i], "--iters") == 0) {
      if( i + 1 >= argc) {
        fprintf( stderr, "--iters requires a value\n");
        return 1;
      }
      cfg->iterations = atoi( argv[++i]);
      if( cfg->iterations < 1) {
        fprintf( stderr, "--iters must be >= 1\n");
        return 1;
      }
      continue;
    }
    if( strcmp( argv[i], "--label") == 0) {
      if( i + 1 >= argc) {
        fprintf( stderr, "--label requires a value\n");
        return 1;
      }
      cfg->label = argv[++i];
      continue;
    }
    if( strcmp( argv[i], "--metrics") == 0) {
      if( i + 1 >= argc) {
        fprintf( stderr, "--metrics requires a path\n");
        return 1;
      }
      cfg->metrics_path = argv[++i];
      continue;
    }
    if( argv[i][0] == '-') {
      fprintf( stderr, "Unknown option: %s\n", argv[i]);
      return 1;
    }
    if( positional == 0) {
      cfg->input_path = argv[i];
    } else if( positional == 1) {
      cfg->output_path = argv[i];
    } else {
      fprintf( stderr, "Too many arguments\n");
      return 1;
    }
    positional++;
  }

  return 0;
}
