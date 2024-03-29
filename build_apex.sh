#!/bin/bash -e

# This script installs NVIDIA Apex with c++ extensions
# https://nvidia.github.io/apex/

echo "Building NVIDIA Apex"

mkdir -p $BUILD_DIR && cd $BUILD_DIR
[ -d apex ] && rm -rf apex
git clone https://github.com/NVIDIA/apex
cd apex

pip install -v --disable-pip-version-check --no-cache-dir --no-build-isolation \
    --config-settings "--build-option=--cpp_ext" \
    --config-settings "--build-option=--cuda_ext" ./
