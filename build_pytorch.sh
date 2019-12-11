#!/bin/bash

set -e

# Configure the installation
source activate.sh

# Configure the build
export CMAKE_PREFIX_PATH=$INSTALL_DIR
export CXX=CC #g++
export CC=cc #gcc
export CRAYPE_LINK_TYPE=dynamic
export USE_CUDA=0
export USE_DISTRIBUTED=1
#export MAX_JOBS=6
# Disabling test builds because of error
export BUILD_TEST=0

# Build PyTorch
cd $BUILD_DIR/pytorch
python setup.py install

# Install torchvision
cd $BUILD_DIR/vision
python setup.py install
