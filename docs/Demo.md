# CIRCT DemoKit: FIRRTL, HW/SV, and PyCDE Pipelines

This demo showcases CIRCT's MLIR-based hardware compilation flows:

- FIRRTL → SystemVerilog via `firtool`
- MLIR HW/SV → SystemVerilog via `circt-translate -export-verilog`
- Optional: PyCDE → MLIR/HW/SV using Python bindings

## Quick Start (Local via Integration Docker)

Ensure submodules are present:
```bash
git submodule update --init --recursive
```

Build CIRCT inside the integration image:
```bash
export CIRCT_INTEGRATION_IMAGE=ghcr.io/circt/images/circt-integration-test:v19.2
./utils/run-docker.sh bash -lc '
  cmake -G Ninja llvm/llvm -B build \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DLLVM_TARGETS_TO_BUILD=host \
    -DLLVM_ENABLE_PROJECTS=mlir \
    -DLLVM_EXTERNAL_PROJECTS=circt \
    -DLLVM_EXTERNAL_CIRCT_SOURCE_DIR=$PWD \
    -DLLVM_ENABLE_LLD=ON \
    -DMLIR_ENABLE_BINDINGS_PYTHON=ON \
    -DCIRCT_BINDINGS_PYTHON_ENABLED=ON \
    -DCIRCT_ENABLE_FRONTENDS=PyCDE \
    -DESI_RUNTIME=ON
  ninja -C build firtool circt-opt mlir-translate
'
```

Run the demo:
```bash
./utils/run-docker.sh bash -lc 'bash scripts/circt-demo.sh'
```

Artifacts in `out/`:
- `blinky.sv` (from FIRRTL)
- `hw_counter.opt.mlir`, `hw_counter.sv` (from MLIR HW/SV)
- Optional PyCDE: `out/pycde/*.sv`

## CI
This repo includes a GitHub Actions workflow that:
- Builds CIRCT in the integration image
- Runs the demo scripts
- Uploads Verilog/MLIR artifacts
