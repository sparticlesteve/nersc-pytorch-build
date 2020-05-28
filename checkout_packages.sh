#!/bin/bash -e

. config.sh
mkdir -p $BUILD_DIR && cd $BUILD_DIR

# Download PyTorch
[ -d pytorch ] && rm -rf pytorch
git clone --recursive --branch $PYTORCH_VERSION $PYTORCH_URL

# Download torchvision
[ -d vision ] && rm -rf vision
git clone --branch $VISION_VERSION https://github.com/pytorch/vision.git
