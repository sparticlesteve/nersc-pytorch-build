#!/bin/bash -e

# This script installs PyTorch geometric and its dependencies
# https://github.com/pyg-team/pytorch_geometric

set -x

# Drop the cray compiler wrappers, they aren't currently working here.
export CXX=g++
export CC=gcc
export TORCH_CUDA_ARCH_LIST=8.0

# Add lib paths to LIBRARY_PATH so linker can find them
# export LD_LIBRARY_PATH="$CONDA_PREFIX/lib:${LD_LIBRARY_PATH}"
# export LIBRARY_PATH=$LD_LIBRARY_PATH:$LIBRARY_PATH

cd $BUILD_DIR

# Build and install the packages via pip, from source.
# Note that PyG prebuilt wheels often fail against our glibc.
export CPPFLAGS="-I${INSTALL_DIR}/include"
export VERBOSE=1
pip install --verbose --no-cache-dir --no-build-isolation \
    git+https://github.com/pyg-team/pyg-lib.git \
    torch_scatter torch_sparse torch_cluster torch_geometric

# Quick sanity check that things are ok
python -c "import torch, pyg_lib, torch_scatter, torch_sparse, torch_cluster, torch_geometric; print(torch.__version__, 'PyG OK')"
