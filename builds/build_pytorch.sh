#!/bin/bash -e

## Basic build config
export PYTORCH_BUILD_VERSION=$PYTORCH_VERSION # to prevent dependency issues
export PYTORCH_BUILD_NUMBER=1
export REL_WITH_DEB_INFO=1

export USE_CUDA=1
export USE_CUDNN=1
export USE_DISTRIBUTED=1
export TORCH_CUDA_ARCH_LIST=8.0
export USE_SYSTEM_NCCL=1
export _GLIBCXX_USE_CXX11_ABI=1 # enable "new" c++ ABI

# Disabling some build components
#export USE_NUMA=0 # Numa features might not work with pure conda build
export BUILD_TEST=0
export USE_NNPACK=0
export USE_QNNPACK=0
export USE_PYTORCH_QNNPACK=0
export USE_XNNPACK=0
#export USE_MPI=0 # Disable MPI

# Trying to pick up additional libs at build time
#export LIBRARY_PATH=$LD_LIBRARY_PATH

# Here I was trying to enable cuda from conda in pytorch build
#export CUDA_HOME=$CONDA_PREFIX
#export LD_LIBRARY_PATH=$CUDA_HOME/lib:$CUDA_HOME/lib64:$LD_LIBRARY_PATH
#export CUDA_INCLUDE_DIRS=$CONDA_PREFIX/targets/x86_64-linux/include
#export CUDA_TOOLKIT_ROOT_DIR=$CONDA_PREFIX
#export CUDNN_INCLUDE_DIR=$CUDA_HOME/include
#export CUDNN_LIB_DIR=$CUDA_HOME/lib
#export CUDNN_ROOT=$CUDA_HOME

# Perform builds in the build dir
cd $BUILD_DIR

# Dump the CUDA environment variables, useful for debugging
env | grep CUDA

# Build PyTorch
echo "Building PyTorch"

# Unless RESUME_PYTORCH_BUILD flag is set, remove existing directory
if [ "${RESUME_PYTORCH_BUILD}" != "true" ]; then
    [ -d pytorch ] && rm -rf pytorch
fi

# Clone the repo is directory doesn't exist
[ -d pytorch ] || git clone --recursive --branch $PYTORCH_BRANCH $PYTORCH_URL

pushd pytorch

# Install additional requirements
pip install -r requirements.txt
pip install mkl-static mkl-include
make triton
python setup.py install

## DEBUGGING cmake issues
#set -x
#python setup.py clean
#python setup.py build --cmake-only
#popd

# Install torchvision
echo "Building torchvision"

# Unless RESUME_PYTORCH_BUILD flag is set, remove existing directory
if [ "${RESUME_PYTORCH_BUILD}" != "true" ]; then
    [ -d vision ] && rm -rf vision
fi

# Clone the repo is directory doesn't exist
[ -d vision ] || git clone --branch $VISION_BRANCH https://github.com/pytorch/vision.git

pushd vision
python setup.py install
popd
