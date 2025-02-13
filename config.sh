# Source me to setup config for the installations

if [ $USER == "swowner" ]; then
    umask 002 # all-readable
    INSTALL_BASE=/global/common/software/nersc9
else
    INSTALL_BASE=$SCRATCH/conda
fi

# Configure the installation
export INSTALL_NAME="pytorch"
export PYTHON_VERSION=3.12
export PYTORCH_VERSION="2.5.1"
export PYTORCH_BRANCH="v${PYTORCH_VERSION}"
export PYTORCH_URL=https://github.com/pytorch/pytorch.git
export VISION_VERSION="0.20.0"
export VISION_BRANCH="v${VISION_VERSION}"
export BUILD_DIR=$SCRATCH/pytorch-build/$INSTALL_NAME/$PYTORCH_VERSION
export INSTALL_DIR=$INSTALL_BASE/$INSTALL_NAME/$PYTORCH_VERSION

# Setup programming environment
module load cmake
module load PrgEnv-gnu gcc-native/12.3
module load cudatoolkit/12.4
#module load cudnn/9.5.0
module load nccl/2.21.5
module unload craype-accel-nvidia80
export MPICH_GPU_SUPPORT_ENABLED=0
export MAX_JOBS=16

# Environment path "fixes"
# - Pick up cuRand and cuSparse from separate directory
#export CMAKE_PREFIX_PATH=/opt/nvidia/hpc_sdk/Linux_x86_64/24.5/math_libs/12.4:$CMAKE_PREFIX_PATH
#export CPATH=${CUDA_HOME}/../../math_libs/include:$CPATH
# - Help pytorch test build find cudnn header
#export CPATH=${CUDNN_DIR}/include:$CPATH

export CXX=CC #g++
export CC=cc #gcc

# Setup conda
module load conda

# Print some stuff
echo "Configuring on $(hostname) as $USER"
echo "  Build directory $BUILD_DIR"
echo "  Install directory $INSTALL_DIR"
module list
