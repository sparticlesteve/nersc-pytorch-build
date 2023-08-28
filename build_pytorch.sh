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

# Trying to pick up additional libs at build time
#export LIBRARY_PATH=$LD_LIBRARY_PATH

# Disable MPI
#export USE_MPI=0

# Using system NCCL
export USE_SYSTEM_NCCL=1

# Disabling some build components
export BUILD_TEST=0
export USE_NNPACK=0
export USE_QNNPACK=0
export USE_PYTORCH_QNNPACK=0
export USE_XNNPACK=0

# Build PyTorch
echo "Building PyTorch"
[ -d pytorch ] && rm -rf pytorch
git clone --recursive --branch ${PYTORCH_BRANCH} $PYTORCH_URL
cd $BUILD_DIR/pytorch
python setup.py install
cd ..

# Install torchvision
echo "Building torchvision"
[ -d vision ] && rm -rf vision
git clone --branch $VISION_BRANCH https://github.com/pytorch/vision.git
cd $BUILD_DIR/vision
python setup.py install

# Now install pip packages that depend on pytorch
pip install --no-cache-dir lightning
pip install --no-cache-dir -v --extra-index-url https://developer.download.nvidia.com/compute/redist --upgrade nvidia-dali-cuda120
