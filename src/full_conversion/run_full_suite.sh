#!/usr/bin/env bash
# Full profiling suite for merged RGB <-> YCC conversion.
#
# For each (image size x configuration):
#   1) force a clean rebuild with the right -D flags
#   2) ensure the matching PPM exists
#   3) run make measure (native wall-time, then Cachegrind)
#
# Chroma down/upsample mode is always 2.
# Run on the Linux ARM VM (needs gcc + valgrind).
#
# Usage (from this directory):
#   ./run_full_suite.sh
#   ITERS_SMALL=500 ITERS_LARGE=20 ./run_full_suite.sh
#   SKIP_CACHEGRIND=1 ./run_full_suite.sh   # wall-time only (faster smoke)

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

ITERS_SMALL="${ITERS_SMALL:-1000}"
ITERS_LARGE="${ITERS_LARGE:-50}"
SKIP_CACHEGRIND="${SKIP_CACHEGRIND:-0}"
DOWNSAMPLE_MODE=2
UPSAMPLE_MODE=2

if ! command -v gcc >/dev/null 2>&1; then
  echo "error: gcc not found" >&2
  exit 1
fi

if [[ "$SKIP_CACHEGRIND" != "1" ]] && ! command -v valgrind >/dev/null 2>&1; then
  cat <<'EOF' >&2
error: valgrind not found (required for Cachegrind).

Install on the VM:
  sudo apt-get update && sudo apt-get install -y valgrind

Or wall-time only:
  SKIP_CACHEGRIND=1 ./run_full_suite.sh
EOF
  exit 1
fi

mkdir -p metrics testimages

measure_cmd() {
  if [[ "$SKIP_CACHEGRIND" == "1" ]]; then
    echo bench
  else
    echo measure
  fi
}

# Force rebuild: Make does not rebuild when only CFLAGS/-D change.
run_case() {
  local large="$1"
  local label="$2"
  local rgb="$3"
  local ycc="$4"
  local iters="$5"
  local size_name

  if [[ "$large" == "1" ]]; then
    size_name="640x480"
  else
    size_name="64x48"
  fi

  echo
  echo "================================================================"
  echo "CASE: label=$label  size=$size_name  RGB=$rgb  YCC=$ycc"
  echo "      downsample=$DOWNSAMPLE_MODE  upsample=$UPSAMPLE_MODE  iters=$iters"
  echo "================================================================"

  make clean-bin

  make prepare-test-image LARGE="$large"

  make "$(measure_cmd)" \
    LARGE="$large" \
    LABEL="$label" \
    ITERS="$iters" \
    RGB_ROUTINE="$rgb" \
    YCC_ROUTINE="$ycc" \
    DOWNSAMPLE_MODE="$DOWNSAMPLE_MODE" \
    UPSAMPLE_MODE="$UPSAMPLE_MODE"

  echo "Finished: $label ($size_name)"
}

echo "Full conversion profiling suite"
echo "  cwd:            $ROOT"
echo "  downsample/up:  $DOWNSAMPLE_MODE / $UPSAMPLE_MODE"
echo "  iters small:    $ITERS_SMALL"
echo "  iters large:    $ITERS_LARGE"
echo "  mode:           $(measure_cmd)"
echo "  wall CSV:       metrics/walltime.csv"
echo "  cachegrind CSV: metrics/cachegrind.csv"
echo
echo "Labels: baseline, lut_no_neon, neon, neon_tiled, neon_fused"
echo "        (+ _large suffix for 640x480 runs)"

# ---- 64x48 ----
run_case 0 baseline     2 2 "$ITERS_SMALL"
run_case 0 lut_no_neon  5 2 "$ITERS_SMALL"
run_case 0 neon         6 4 "$ITERS_SMALL"
run_case 0 neon_tiled   4 4 "$ITERS_SMALL"
run_case 0 neon_fused   6 5 "$ITERS_SMALL"

# ---- 640x480 ----
run_case 1 baseline_large     2 2 "$ITERS_LARGE"
run_case 1 lut_no_neon_large  5 2 "$ITERS_LARGE"
run_case 1 neon_large         6 4 "$ITERS_LARGE"
run_case 1 neon_tiled_large   4 4 "$ITERS_LARGE"
run_case 1 neon_fused_large   6 5 "$ITERS_LARGE"

# Drop the last binary so the next manual build cannot accidentally reuse
# the final suite's -D flags without a rebuild.
make clean-bin

echo
echo "================================================================"
echo "Suite complete."
echo "  Wall-time:   metrics/walltime.csv"
echo "  Cachegrind:  metrics/cachegrind.csv"
if [[ "$SKIP_CACHEGRIND" != "1" ]]; then
  echo "  Raw/annotate files: metrics/cachegrind/"
fi
echo "================================================================"
