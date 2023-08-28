# Source me to setup config for the installations

if [ $USER == "swowner" ]; then
    umask 002 # all-readable
    INSTALL_BASE=/global/common/software/nersc/pm-2022q4/sw
else
    INSTALL_BASE=$SCRATCH/conda
fi

# Configure the installation
export INSTALL_NAME="pytorch"
export PYTHON_VERSION=3.10
export PYTORCH_VERSION="2.1.0-rc1"
export PYTORCH_BRANCH="v${PYTORCH_VERSION}"
export PYTORCH_URL=https://github.com/pytorch/pytorch.git
#export VISION_VERSION="0.15.2"
export VISION_BRANCH="main"
export BUILD_DIR=$SCRATCH/pytorch-build/$INSTALL_NAME/$PYTORCH_VERSION
export INSTALL_DIR=$INSTALL_BASE/$INSTALL_NAME/$PYTORCH_VERSION

# Setup programming environment
module load cmake
module load PrgEnv-gnu gcc/11.2.0
module load cudatoolkit/12.0
module load cudnn/8.9.3_cuda12
module load nccl/2.18.3-cu12
module load evp-patch
module unload craype-accel-nvidia80
export MPICH_GPU_SUPPORT_ENABLED=0
export MAX_JOBS=16

# Environment path "fixes"
# - Pick up cuRand and cuSparse from separate directory
export CMAKE_PREFIX_PATH=/opt/nvidia/hpc_sdk/Linux_x86_64/23.1/math_libs/12.0:$CMAKE_PREFIX_PATH
#export CPATH=${CUDA_HOME}/../../math_libs/include:$CPATH
# - Help pytorch test build find cudnn header
export CPATH=${CUDNN_DIR}/include:$CPATH

export CXX=CC #g++
export CC=cc #gcc

# Setup conda
export CONDA_INIT_SCRIPT=/global/common/software/nersc/pm-2022q3/sw/python/3.9-anaconda-2021.11/etc/profile.d/conda.sh
source $CONDA_INIT_SCRIPT

# Print some stuff
echo "Configuring on $(hostname) as $USER"
echo "  Build directory $BUILD_DIR"
echo "  Install directory $INSTALL_DIR"
module list
