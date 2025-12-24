#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="${OUT_DIR:-out}"
mkdir -p "${OUT_DIR}"

# Verify tools exist in PATH (run inside integration container)
command -v firtool >/dev/null || { echo "firtool not found"; exit 1; }
command -v circt-opt >/dev/null || { echo "circt-opt not found"; exit 1; }
command -v mlir-translate >/dev/null || { echo "mlir-translate not found"; exit 1; }

echo "[FIRRTL] Compiling samples/firrtl/blinky.fir -> SystemVerilog"
firtool samples/firrtl/blinky.fir -o "${OUT_DIR}/blinky.sv"

echo "[HW/SV] Optimizing samples/mlir/hw_counter.mlir"
circt-opt -o "${OUT_DIR}/hw_counter.opt.mlir" \
  -passes="canonicalize,cse" \
  samples/mlir/hw_counter.mlir

echo "[HW/SV] Translating optimized MLIR -> SystemVerilog"
mlir-translate -export-verilog "${OUT_DIR}/hw_counter.opt.mlir" > "${OUT_DIR}/hw_counter.sv"

echo "Artifacts written to ${OUT_DIR}"
