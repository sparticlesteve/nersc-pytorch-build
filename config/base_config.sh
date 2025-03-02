# Source me to setup config for the installations

source "$(dirname "${BASH_SOURCE[0]}")/../utils/logging.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../utils/validation.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../utils/env_utils.sh"

# Improve this
if [ $USER == "swowner" ]; then
    umask 002 # all-readable
    INSTALL_BASE=/global/common/software/nersc9
else
    INSTALL_BASE=$SCRATCH/conda
fi

# Configure the installation
export INSTALL_NAME="pytorch"
export PYTHON_VERSION=3.12
export PYTORCH_VERSION="2.6.0"
export PYTORCH_BRANCH="v${PYTORCH_VERSION}"
export PYTORCH_URL=https://github.com/pytorch/pytorch.git
export VISION_VERSION="0.21.0"
export VISION_BRANCH="v${VISION_VERSION}"
export RESUME_PYTORCH_BUILD=${RESUME_PYTORCH_BUILD:-false}
#export CUDA_VERSION=12.6 # previously used to control conda install
export BUILD_DIR=$SCRATCH/pytorch-build/$INSTALL_NAME/$PYTORCH_VERSION
export INSTALL_DIR=$INSTALL_BASE/$INSTALL_NAME/$PYTORCH_VERSION
export CMAKE_PREFIX_PATH=$INSTALL_DIR:${CMAKE_PREFIX_PATH:-}

# Setup programming environment
module load conda
module load cmake
module load PrgEnv-gnu gcc-native/13.2
module load cudatoolkit/12.4
module load cudnn/9.5.0
module load nccl/2.24.3
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

# Validate configuration
validate_env_vars #|| exit 1
validate_dependencies #|| exit 1

# Print some stuff
echo "Configuring on $(hostname) as $USER"
echo "  Build directory $BUILD_DIR"
echo "  Install directory $INSTALL_DIR"
module list
