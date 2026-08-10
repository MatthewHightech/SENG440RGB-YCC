#ifndef CSC_HARNESS_H
#define CSC_HARNESS_H

#include <stdint.h>
#include "CSC_global.h"

#define CSC_DEFAULT_INPUT    "testimages/input.ppm"
#define CSC_DEFAULT_OUTPUT   "testimages/output.ppm"
#define CSC_DEFAULT_WALL_CSV "metrics/walltime.csv"
#define CSC_DEFAULT_ITERS    1000

typedef struct {
  const char *input_path;
  const char *output_path;
  const char *metrics_path;
  const char *label;
  int iterations;
  int show_help;
} CSC_RunConfig;

typedef struct {
  double rgb_to_ycc_ms_mean;
  double ycc_to_rgb_ms_mean;
  double ycc_to_rgb_ms_min;
  double total_ms_mean;
  double mpix_per_s;
  double ns_per_pixel;
  int diff_max;
  double mean_abs_delta;
} CSC_WallMetrics;

/* Monotonic wall time in nanoseconds. */
uint64_t csc_now_ns( void);

/* Parse argv into config. Returns 0 on success, non-zero on error. */
int csc_parse_args( int argc, char *argv[], CSC_RunConfig *cfg);
void csc_print_usage( const char *program);

int csc_load_input_image( const char *path);
int csc_write_ppm( const char *path);

void csc_snapshot_rgb(
    uint8_t R_dst[IMAGE_ROW_SIZE][IMAGE_COL_SIZE],
    uint8_t G_dst[IMAGE_ROW_SIZE][IMAGE_COL_SIZE],
    uint8_t B_dst[IMAGE_ROW_SIZE][IMAGE_COL_SIZE]);

void csc_restore_rgb(
    const uint8_t R_src[IMAGE_ROW_SIZE][IMAGE_COL_SIZE],
    const uint8_t G_src[IMAGE_ROW_SIZE][IMAGE_COL_SIZE],
    const uint8_t B_src[IMAGE_ROW_SIZE][IMAGE_COL_SIZE]);

void csc_compute_quality(
    const uint8_t R_orig[IMAGE_ROW_SIZE][IMAGE_COL_SIZE],
    const uint8_t G_orig[IMAGE_ROW_SIZE][IMAGE_COL_SIZE],
    const uint8_t B_orig[IMAGE_ROW_SIZE][IMAGE_COL_SIZE],
    int *diff_max_out,
    double *mean_abs_delta_out);

void csc_fill_wall_metrics(
    int iterations,
    uint64_t rgb_ns_sum,
    uint64_t ycc_ns_sum,
    uint64_t ycc_ns_min,
    int diff_max,
    double mean_abs_delta,
    CSC_WallMetrics *out);

void csc_print_wall_metrics(
    const CSC_RunConfig *cfg,
    const CSC_WallMetrics *m);

/* Append CSV unless metrics_path is /dev/null (Cachegrind runs). */
int csc_report_wall_metrics(
    const CSC_RunConfig *cfg,
    const CSC_WallMetrics *m);

#endif /* CSC_HARNESS_H */
