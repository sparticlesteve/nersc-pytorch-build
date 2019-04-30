#!/bin/bash

# Configure the installation
source ./config.sh
conda activate $INSTALL_DIR

# Configure the build
export CMAKE_PREFIX_PATH=$INSTALL_DIR
export CXX=CC #g++
export CC=cc #gcc
export CRAYPE_LINK_TYPE=dynamic
export NO_CUDA=1
export WITH_DISTRIBUTED=1
export MAX_JOBS=4

# Download PyTorch
mkdir -p $BUILD_DIR && cd $BUILD_DIR
git clone --recursive --branch $PYTORCH_VERSION $PYTORCH_URL
cd pytorch

# Build PyTorch; calling build twice because first always fails due to
# weird interaction between compiler wrapper flags and pytorch build flags.
# Rebuilding seems to fix it.
python setup.py build
python setup.py build
python setup.py install

# Download torchvision
cd ..
git clone --branch $VISION_VERSION https://github.com/pytorch/vision.git
cd vision
python setup.py install
