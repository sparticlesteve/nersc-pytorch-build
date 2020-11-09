#!/bin/bash -e

# Setup the environment
source config.sh
conda activate $INSTALL_DIR

# Install PyTorch, torchvision, and cuda via conda
conda install -y pytorch=$PYTORCH_VERSION torchvision=$VISION_VERSION cudatoolkit=10.2 -c pytorch

# Install Apex
mkdir -p $BUILD_DIR && cd $BUILD_DIR
git clone https://github.com/NVIDIA/apex
cd apex
pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./
