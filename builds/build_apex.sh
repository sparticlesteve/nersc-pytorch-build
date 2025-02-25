#!/bin/bash -e

# This script installs NVIDIA Apex with c++ extensions
# https://nvidia.github.io/apex/

echo "Building NVIDIA Apex"
cd $BUILD_DIR

[ -d apex ] && rm -rf apex
git clone https://github.com/NVIDIA/apex
cd apex

export TORCH_CUDA_ARCH_LIST=8.0

pip install -v --disable-pip-version-check --no-cache-dir --no-build-isolation \
    --config-settings "--build-option=--cpp_ext" \
    --config-settings "--build-option=--cuda_ext" ./
