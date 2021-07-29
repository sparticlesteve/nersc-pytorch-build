#!/bin/bash -e

# This script installs NVIDIA Apex with c++ extensions
# https://nvidia.github.io/apex/

echo "Building NVIDIA Apex"

mkdir -p $BUILD_DIR && cd $BUILD_DIR
git clone https://github.com/NVIDIA/apex
cd apex

pip install -v --disable-pip-version-check --no-cache-dir \
    --global-option="--cpp_ext" --global-option="--cuda_ext" ./
