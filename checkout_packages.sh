#!/bin/bash -e

. config.sh
mkdir -p $BUILD_DIR && cd $BUILD_DIR

# Download PyTorch
[ -d pytorch ] && rm -rf pytorch
git clone --recursive --branch v${PYTORCH_VERSION} $PYTORCH_URL

# Download torchvision
[ -d vision ] && rm -rf vision
git clone --branch v${VISION_VERSION} https://github.com/pytorch/vision.git
