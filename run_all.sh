#!/bin/bash
# run_all.sh - Runs every model and writes a summary of the verdicts.
#
# Usage:
#   ./run_all.sh
#
# Requires ProVerif 2.05 (opam install proverif).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RESULTS_DIR="$SCRIPT_DIR/results"
SUMMARY="$RESULTS_DIR/summary.txt"

mkdir -p "$RESULTS_DIR"

{
  echo "=== ProVerif verification: delegated authentication under mediated access ==="
  echo "ProVerif version: $(proverif -help 2>&1 | head -1 || true)"
  echo
} > "$SUMMARY"

for f in "$SCRIPT_DIR"/cat*.pv; do
  name=$(basename "$f" .pv)
  log="$RESULTS_DIR/${name}.log"
  echo "--- $name ---" | tee -a "$SUMMARY"
  ( cd "$SCRIPT_DIR" && proverif -lib common.pvl "$(basename "$f")" ) > "$log" 2>&1 || true
  grep "^RESULT" "$log" | tee -a "$SUMMARY"
  echo | tee -a "$SUMMARY"
done
