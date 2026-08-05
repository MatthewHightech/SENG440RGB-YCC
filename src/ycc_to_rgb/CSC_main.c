// CSC round-trip entry point: load RGB, convert RGB<->YCC, write PPM.
// I/O, CLI, and wall-time reporting live in CSC_harness.c.

#include <stdio.h>
#include <stdint.h>

#define GLOBAL
#include "CSC_global.h"
#include "CSC_harness.h"

int main( int argc, char *argv[]) {
  CSC_RunConfig cfg;
  CSC_WallMetrics metrics;
  uint8_t R_orig[IMAGE_ROW_SIZE][IMAGE_COL_SIZE];
  uint8_t G_orig[IMAGE_ROW_SIZE][IMAGE_COL_SIZE];
  uint8_t B_orig[IMAGE_ROW_SIZE][IMAGE_COL_SIZE];
  int i;
  int diff_max = 0;
  double mean_abs_delta = 0.0;
  uint64_t rgb_ns_sum = 0;
  uint64_t ycc_ns_sum = 0;
  uint64_t ycc_ns_min = UINT64_MAX;

  if( csc_parse_args( argc, argv, &cfg) != 0) {
    csc_print_usage( argv[0]);
    return 1;
  }
  if( cfg.show_help) {
    csc_print_usage( argv[0]);
    return 0;
  }

  if( csc_load_input_image( cfg.input_path) != 0) {
    return 1;
  }

  csc_snapshot_rgb( R_orig, G_orig, B_orig);

  /* Warmup (not timed). */
  csc_restore_rgb( R_orig, G_orig, B_orig);
  CSC_RGB_to_YCC();
  CSC_YCC_to_RGB();

  /* Timed round-trips. */
  for( i=0; i < cfg.iterations; i++) {
    uint64_t t0, t1, t2;
    uint64_t rgb_ns, ycc_ns;

    csc_restore_rgb( R_orig, G_orig, B_orig);

    t0 = csc_now_ns();
    CSC_RGB_to_YCC();
    t1 = csc_now_ns();
    CSC_YCC_to_RGB();
    t2 = csc_now_ns();

    rgb_ns = t1 - t0;
    ycc_ns = t2 - t1;
    rgb_ns_sum += rgb_ns;
    ycc_ns_sum += ycc_ns;
    if( ycc_ns < ycc_ns_min) {
      ycc_ns_min = ycc_ns;
    }
  }

  csc_compute_quality( R_orig, G_orig, B_orig, &diff_max, &mean_abs_delta);

  if( csc_write_ppm( cfg.output_path) != 0) {
    return 1;
  }

  csc_fill_wall_metrics( cfg.iterations, rgb_ns_sum, ycc_ns_sum, ycc_ns_min,
                         diff_max, mean_abs_delta, &metrics);

  return csc_report_wall_metrics( &cfg, &metrics);
}
