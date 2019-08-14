#!/bin/bash -e

# Configure the installation
source ./config.sh
conda activate $INSTALL_DIR

# Configure the build
export CMAKE_PREFIX_PATH=$INSTALL_DIR
export CXX=mpic++ #g++
export CC=mpicc #gcc
#export CRAYPE_LINK_TYPE=dynamic
#export USE_SYSTEM_NCCL=1 # no effect?
export USE_CUDA=1
export USE_DISTRIBUTED=1
export MAX_JOBS=40

# Disabling Caffe2 ops because of a current build issue
export BUILD_CAFFE2_OPS=0

# Build for V100 GPU only
# https://discuss.pytorch.org/t/pytorch-1-2-0-build-fails-on-error-identifier-ldg-is-undefined/52409
export TORCH_CUDA_ARCH_LIST=7.0

# Download PyTorch
mkdir -p $BUILD_DIR && cd $BUILD_DIR
[ -d pytorch ] && rm -rf pytorch
git clone --recursive --branch $PYTORCH_VERSION $PYTORCH_URL
cd pytorch

# Build PyTorch
python setup.py install

# Download torchvision
cd ..
git clone --branch $VISION_VERSION https://github.com/pytorch/vision.git
cd vision
python setup.py install
