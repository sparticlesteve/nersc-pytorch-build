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
export MAX_JOBS=5

# Download PyTorch
mkdir -p $BUILD_DIR && cd $BUILD_DIR
git clone --recursive $PYTORCH_URL
cd pytorch
git checkout $PYTORCH_VERSION 
git submodule update --recursive

# Build PyTorch
python setup.py install

# Download torchvision
cd ..
git clone --branch $VISION_VERSION https://github.com/pytorch/vision.git
cd vision
python setup.py install
