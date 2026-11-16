#!/usr/bin/env bash
# Runs the model in model/ on this machine and uploads its boxes to CVAT, the same way your own
# model would plug in.
# Usage: bash scripts/auto_annotate.sh           replaces the boxes in the task with this model's boxes
#        bash scripts/auto_annotate.sh --keep    keeps the existing boxes and adds to them (expect doubles)
# The answer key is never touched. scripts/restore.sh on a fresh CVAT brings the original back.
# First run downloads PyTorch (about 300 MB) and the model weights (about 75 MB).
set -euo pipefail
source "$(dirname "$0")/common.sh"
[ -n "${DEMO_PASS:-}" ] || { echo "Run: bash scripts/setup.sh first."; exit 1; }
[ -f demo/local-urls.txt ] || { echo "Run: bash scripts/restore.sh first."; exit 1; }
MAIN_TASK_ID="$(grep '^task_id=' demo/local-urls.txt | cut -d= -f2)"
RUN_TASK_ID="$(grep '^run_task_id=' demo/local-urls.txt | cut -d= -f2 || true)"
TASK_ID="${RUN_TASK_ID:-$MAIN_TASK_ID}"
EXTRA=(--clear-existing)
for arg in "$@"; do
  case "$arg" in
    --main) TASK_ID="$MAIN_TASK_ID" ;;
    --keep) EXTRA=() ;;
    *) echo "Unknown option: $arg (use --main and/or --keep)"; exit 1 ;;
  esac
done
if ! .venv/bin/python -c 'import torchvision' 2>/dev/null; then
  if [ "$(uname -s)" = "Linux" ] && grep -q '^torch' model/requirements.txt; then
    # On Linux the default PyTorch build includes GPU libraries (several GB). The CPU build is enough here.
    .venv/bin/pip install -q -r model/requirements.txt --extra-index-url https://download.pytorch.org/whl/cpu
  else
    .venv/bin/pip install -q -r model/requirements.txt
  fi
fi
echo "Running model/person_det_func.py on task $TASK_ID ..."
PASS="$DEMO_PASS" .venv/bin/cvat-cli --server-host "$CVAT_URL" --auth "$DEMO_USER" \
  task auto-annotate "$TASK_ID" --function-file model/person_det_func.py --conf-threshold 0.5 ${EXTRA[@]+"${EXTRA[@]}"}
echo "Done. Open $CVAT_URL/tasks/$TASK_ID and a job in it to see the boxes."
if [ "$TASK_ID" = "$MAIN_TASK_ID" ]; then echo "Then score them: bash scripts/quality_report.sh"; fi
