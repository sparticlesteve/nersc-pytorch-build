#!/bin/bash

# Configure the installation
source ./config.sh
conda activate $INSTALL_DIR

# Configure the build
export CMAKE_PREFIX_PATH=$INSTALL_DIR
export CXX=mpic++ #g++
export CC=mpicc #gcc
#export CRAYPE_LINK_TYPE=dynamic
#export NO_CUDA=1
export WITH_DISTRIBUTED=1
export USE_SYSTEM_NCCL=1
export MAX_JOBS=5

# Download PyTorch
mkdir -p $BUILD_DIR && cd $BUILD_DIR
git clone --recursive --branch $PYTORCH_VERSION $PYTORCH_URL
cd pytorch

# Build PyTorch
python setup.py install

# Download torchvision
cd ..
git clone --branch $VISION_VERSION https://github.com/pytorch/vision.git
cd vision
python setup.py install
