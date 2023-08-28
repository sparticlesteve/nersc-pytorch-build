# Source me to setup config for the installations

if [ $USER == "swowner" ]; then
    umask 002 # all-readable
    INSTALL_BASE=/usr/common/software
else
    INSTALL_BASE=$SCRATCH/conda
fi

# Configure the installation
export INSTALL_NAME="pytorch"
export PYTHON_VERSION=3.9
export PYTORCH_VERSION="1.10.2"
export PYTORCH_URL=https://github.com/pytorch/pytorch
export VISION_VERSION="0.11.3"
export SYSTEM_ARCH=gpu
export BUILD_DIR=$SCRATCH/pytorch-build/$INSTALL_NAME/$PYTORCH_VERSION-gpu
export INSTALL_DIR=$INSTALL_BASE/$INSTALL_NAME/$PYTORCH_VERSION-gpu

# Setup programming environment
module purge
module load cgpu

# OpenMPI setup
module load gcc/9.3.0
module load cuda/11.3.0
module load cudnn/8.3.2
#module load nccl/2.5.6
module load openmpi/4.0.6
export LD_LIBRARY_PATH=$INSTALL_DIR/lib/python${PYTHON_VERSION}/site-packages/torch/lib:$LD_LIBRARY_PATH
export UCX_LOG_LEVEL=error
export NCCL_IB_HCA=mlx5_0:1,mlx5_2:1,mlx5_4:1,mlx5_6:1
export NCCL_SOCKET_IFNAME=eth

# Setup conda
export CONDA_INIT_SCRIPT=/usr/common/software/python/3.9-anaconda-2021.11/etc/profile.d/conda.sh
source $CONDA_INIT_SCRIPT

# Print some stuff
echo "Configuring on $(hostname) as $USER for $SYSTEM_ARCH"
echo "  Build directory $BUILD_DIR"
echo "  Install directory $INSTALL_DIR"