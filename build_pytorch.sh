#!/bin/bash -e

# Setup the environment
source config.sh
conda activate $INSTALL_DIR

# Basic build config
export CMAKE_PREFIX_PATH=$INSTALL_DIR
export PYTORCH_BUILD_VERSION=$PYTORCH_VERSION # to prevent dependency issues
export PYTORCH_BUILD_NUMBER=1
export REL_WITH_DEB_INFO=1

# Cori-GPU system build config
if [[ $SYSTEM_ARCH == "gpu" ]]; then
    # Use MPI compiler wrappers
    export CXX=mpic++ #g++
    export CC=mpicc #gcc
    export USE_CUDA=1
    # Using system NCCL
    export USE_SYSTEM_NCCL=1
    export NCCL_ROOT=$NCCL_DIR
    export NCCL_INCLUDE_DIR=$NCCL_DIR/include
    export NCCL_LIB_DIR=$NCCL_DIR/lib
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
cd $BUILD_DIR/pytorch
python setup.py clean
python setup.py install

# Install torchvision
echo "Building torchvision"
cd $BUILD_DIR/vision
python setup.py clean
# Cray compiler wrappers fail the validity checks in torch extensions,
# so here we just explicitly use the bare gnu compiler commands.
CXX=g++ CC=gcc python setup.py install
