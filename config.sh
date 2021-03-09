# Source me to setup config for the installations

if [ $USER == "swowner" ]; then
    umask 002 # all-readable
    INSTALL_BASE=/usr/common/software
else
    INSTALL_BASE=$SCRATCH/conda
fi

# Configure the installation
export INSTALL_NAME="pytorch"
export PYTHON_VERSION=3.8
export PYTORCH_VERSION="1.8.0"
export PYTORCH_URL=https://github.com/pytorch/pytorch
export VISION_VERSION="0.9.0"
export SYSTEM_ARCH=gpu
if [[ $SYSTEM_ARCH == "gpu" ]]; then
    export BUILD_DIR=$SCRATCH/pytorch-build/$INSTALL_NAME/$PYTORCH_VERSION-gpu
    export INSTALL_DIR=$INSTALL_BASE/$INSTALL_NAME/$PYTORCH_VERSION-gpu
else
    export BUILD_DIR=$SCRATCH/pytorch-build/$INSTALL_NAME/$PYTORCH_VERSION
    export INSTALL_DIR=$INSTALL_BASE/$INSTALL_NAME/$PYTORCH_VERSION
fi

# Setup programming environment
if [[ $SYSTEM_ARCH == "gpu" ]]; then
    module purge
    module load cgpu

    # OpenMPI setup
    module load gcc/8.3.0
    module load cuda/11.1.1
    module load cudnn/8.0.5
    #module load nccl/2.5.6
    module load openmpi/4.0.3
    export LD_LIBRARY_PATH=$INSTALL_DIR/lib/python3.8/site-packages/torch/lib:$LD_LIBRARY_PATH
    export UCX_LOG_LEVEL=error
    export NCCL_IB_HCA=mlx5_0:1,mlx5_2:1,mlx5_4:1,mlx5_6:1

    # mvapich setup
    #module load gcc/7.3.0
    #module load cuda/10.1.168
    #module load mvapich2/2.3.2
    #export MV2_ENABLE_AFFINITY=0
    #export LD_PRELOAD=$MVAPICH2_DIR/lib/libmpi.so
    #export MV2_USE_CUDA=1

else
    module load gcc/8.3.0
    module unload PrgEnv-intel
    module load PrgEnv-gnu
    module unload craype-hugepages2M
    module unload cray-libsci
    module unload atp
fi

# Setup conda
source /usr/common/software/python/3.8-anaconda-2020.11/etc/profile.d/conda.sh

# Print some stuff
echo "Configuring on $(hostname) as $USER for $SYSTEM_ARCH"
echo "  Build directory $BUILD_DIR"
echo "  Install directory $INSTALL_DIR"
