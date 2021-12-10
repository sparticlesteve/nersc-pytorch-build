# Source me to setup config for the installations

if [ $USER == "swowner" ]; then
    umask 002 # all-readable
    INSTALL_BASE=/global/common/software/nersc/pm-2021q4/sw
    #INSTALL_BASE=/global/common/software/nersc/shasta2105
else
    INSTALL_BASE=$SCRATCH/conda
fi

# Configure the installation
#export CPATH=""
export INSTALL_NAME="pytorch"
export PYTHON_VERSION=3.9
export PYTORCH_VERSION="1.10.0"
export PYTORCH_URL=https://github.com/pytorch/pytorch
export VISION_VERSION="0.11.1"
export BUILD_DIR=$SCRATCH/pytorch-build/$INSTALL_NAME/$PYTORCH_VERSION
export INSTALL_DIR=$INSTALL_BASE/$INSTALL_NAME/$PYTORCH_VERSION

# FIXME: temporary workaround for missing modulefiles in shasta-21.11
#module use /global/homes/s/sfarrell/WorkAreas/software/modulefiles/shasta-21.11/extra_modulefiles

# Setup programming environment
module load cmake
module load PrgEnv-gnu #gcc/9.3.0
module load cudatoolkit/21.9_11.4
#module load cuda/11.3.0

# Pick up cuRand and cuSparse from separate directory

# Manual cudnn setup
export CUDNN_VERSION=8.2.0
export CUDNN_DIR=/global/common/software/nersc/cos1.3/cudnn/8.2.0/cuda/11.3
export CMAKE_PREFIX_PATH=$CUDNN_DIR:$CMAKE_PREFIX_PATH
export LD_LIBRARY_PATH=$CUDNN_DIR/lib64:$LD_LIBRARY_PATH
#module load cudnn/8.2.0

# Manual nccl setup
export NCCL_DIR=/opt/nvidia/hpc_sdk/Linux_x86_64/21.9/comm_libs/nccl
export NCCL_VERSION=2.11.4
#module load nccl/2.11.4

export CXX=CC #g++
export CC=cc #gcc

# Setup conda
#export CONDA_INIT_SCRIPT=/global/common/software/nersc/shasta2105/python/3.8-anaconda-2021.05/etc/profile.d/conda.sh
export CONDA_INIT_SCRIPT=/global/common/software/nersc/pm-2021q4/sw/python/3.9-anaconda-2021.11/etc/profile.d/conda.sh
source $CONDA_INIT_SCRIPT

# Print some stuff
echo "Configuring on $(hostname) as $USER"
echo "  Build directory $BUILD_DIR"
echo "  Install directory $INSTALL_DIR"
module list
