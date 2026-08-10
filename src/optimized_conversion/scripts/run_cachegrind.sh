#!/usr/bin/env bash
# Run Cachegrind on the CSC binary and parse instruction / miss metrics.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

LABEL="${LABEL:-baseline}"
BINARY="${BINARY:-./csc_full_conversion}"
INPUT="${INPUT:-testimages/input.ppm}"
OUTPUT="${OUTPUT:-testimages/output.ppm}"
OUTDIR="${OUTDIR:-metrics/cachegrind}"
CSV="${CSV:-metrics/cachegrind.csv}"
# One conversion under Cachegrind: Ir/misses stay comparable and runs finish faster.
ITERS="${ITERS:-1}"

if ! command -v valgrind >/dev/null 2>&1; then
  cat <<'EOF' >&2
error: valgrind not found.

Cachegrind must run on a Linux machine (your ARM VM), not typically on
Apple Silicon macOS.

On the VM:
  sudo apt-get update
  sudo apt-get install -y valgrind

Then rebuild/run there, or: make cachegrind
EOF
  exit 1
fi

if [[ ! -x "$BINARY" ]]; then
  echo "error: binary not found or not executable: $BINARY" >&2
  echo "Build first with: make native-profile" >&2
  exit 1
fi

if [[ ! -f "$INPUT" ]]; then
  echo "error: input image not found: $INPUT" >&2
  echo "Create it with: make prepare-test-image" >&2
  exit 1
fi

mkdir -p "$OUTDIR"
STAMP="$(date +%Y%m%d-%H%M%S)"
SAFE_LABEL="$(echo "$LABEL" | tr ' /' '__')"
OUTFILE="$OUTDIR/${SAFE_LABEL}-${STAMP}.out"
ANNOTATE="$OUTDIR/${SAFE_LABEL}-${STAMP}.annotate.txt"

echo "Running Cachegrind..."
echo "  binary: $BINARY"
echo "  label:  $LABEL"
echo "  iters:  $ITERS (use 1 under Cachegrind)"
echo "  out:    $OUTFILE"

# --branch-sim=no keeps the run focused on instruction + cache metrics.
# Wall-time printed by the binary under Valgrind is NOT meaningful.
valgrind \
  --tool=cachegrind \
  --cache-sim=yes \
  --branch-sim=no \
  --cachegrind-out-file="$OUTFILE" \
  "$BINARY" "$INPUT" "$OUTPUT" --iters "$ITERS" --label "$LABEL" \
  --metrics /dev/null

echo
echo "Writing annotated report to $ANNOTATE"
cg_annotate --auto=yes "$OUTFILE" > "$ANNOTATE"

echo
python3 scripts/parse_cachegrind.py "$OUTFILE" --label "$LABEL" --csv "$CSV"

echo
echo "Done."
echo "  Raw:       $OUTFILE"
echo "  Annotated: $ANNOTATE"
echo "  CSV:       $CSV"
echo
echo "Tip: compare Ir and D1/LL misses across labels in $CSV"
echo "     Focus on CSC_YCC_to_RGB / CSC_RGB_to_YCC in the annotate file."
