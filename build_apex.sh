#!/bin/bash -e

# This script installs NVIDIA Apex with c++ extensions
# https://nvidia.github.io/apex/

# Configure the installation
source ./config.sh
conda activate $INSTALL_DIR
echo "Building NVIDIA Apex"

cd $BUILD_DIR
git clone https://github.com/NVIDIA/apex
cd apex

pip install -v --disable-pip-version-check --no-cache-dir \
    --global-option="--cpp_ext" --global-option="--cuda_ext" ./
