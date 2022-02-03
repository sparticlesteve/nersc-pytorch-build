#!/bin/bash -e

# Basic build config
export CMAKE_PREFIX_PATH=$INSTALL_DIR
export PYTORCH_BUILD_VERSION=$PYTORCH_VERSION # to prevent dependency issues
export PYTORCH_BUILD_NUMBER=1
export REL_WITH_DEB_INFO=1
mkdir -p $BUILD_DIR && cd $BUILD_DIR

# Cori-GPU system build config
if [[ $SYSTEM_ARCH == "gpu" ]]; then
    # Use MPI compiler wrappers
    export CXX=mpic++ #g++
    export CC=mpicc #gcc
    export USE_CUDA=1
    export CUDNN_ROOT=$CUDNN_DIR
    export USE_DISTRIBUTED=1
    # Build for V100 GPU only; maybe not needed when GPU is visible
    # discuss.pytorch.org/t/pytorch-1-2-0-build-fails-on-error-identifier-ldg-is-undefined/52409
    export TORCH_CUDA_ARCH_LIST=7.0

# Cori CPU system build config
else
    # Use Cray compiler wrappers
    export CXX=CC #g++
    export CC=cc #gcc
    export CRAYPE_LINK_TYPE=dynamic
    export USE_CUDA=0
    export USE_MKLDNN=1
    export USE_DISTRIBUTED=1
    export MAX_JOBS=6
    # Disabling test builds because of error
    export BUILD_TEST=0
fi

# Build PyTorch
echo "Building PyTorch"
[ -d pytorch ] && rm -rf pytorch
git clone --recursive --branch v${PYTORCH_VERSION} $PYTORCH_URL
cd pytorch
python setup.py install
cd ..

# Install torchvision
echo "Building torchvision"
[ -d vision ] && rm -rf vision
git clone --branch v${VISION_VERSION} https://github.com/pytorch/vision.git
cd vision
# Cray compiler wrappers fail the validity checks in torch extensions,
# so here we just explicitly use the bare gnu compiler commands.
CXX=g++ CC=gcc python setup.py install
