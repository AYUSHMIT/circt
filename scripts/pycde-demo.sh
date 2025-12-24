#!/usr/bin/env bash
set -euo pipefail
OUT_DIR="${OUT_DIR:-out}"
mkdir -p "${OUT_DIR}/pycde"

python3 samples/pycde/demo.py
echo "PyCDE artifacts in ${OUT_DIR}/pycde"
