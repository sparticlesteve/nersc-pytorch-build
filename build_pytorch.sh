#!/bin/bash -e

# Basic build config
export CMAKE_PREFIX_PATH=$INSTALL_DIR:$CMAKE_PREFIX_PATH
export PYTORCH_BUILD_VERSION=$PYTORCH_VERSION # to prevent dependency issues
export PYTORCH_BUILD_NUMBER=1
export REL_WITH_DEB_INFO=1
mkdir -p $BUILD_DIR && cd $BUILD_DIR

export USE_CUDA=1
export USE_DISTRIBUTED=1
export TORCH_CUDA_ARCH_LIST=8.0

# Using system NCCL
export USE_SYSTEM_NCCL=1
export NCCL_ROOT=$NCCL_DIR
export NCCL_INCLUDE_DIR=$NCCL_DIR/include
export NCCL_LIB_DIR=$NCCL_DIR/lib

# Disabling test builds because of error
#export BUILD_TEST=0
#export CUDNN_ROOT=$CUDNN_DIR

# Build PyTorch
echo "Building PyTorch"
[ -d pytorch ] && rm -rf pytorch
git clone --recursive --branch v${PYTORCH_VERSION} $PYTORCH_URL
cd $BUILD_DIR/pytorch
python setup.py install
cd ..

# Install torchvision
echo "Building torchvision"
[ -d vision ] && rm -rf vision
git clone --branch v${VISION_VERSION} https://github.com/pytorch/vision.git
cd $BUILD_DIR/vision
python setup.py install
