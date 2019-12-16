# Source me to setup config for the installations

if [ $USER == "swowner" ]; then
    umask 002 # all-readable
    INSTALL_BASE=/usr/common/software
else
    INSTALL_BASE=$SCRATCH/conda
fi

# Configure the installation
export INSTALL_NAME="pytorch"
export PYTHON_VERSION=3.6
export PYTORCH_VERSION="v1.3.1"
export PYTORCH_URL=https://github.com/pytorch/pytorch
export VISION_VERSION="v0.4.2"
export SYSTEM_ARCH=gpu #cpu
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

    # Vanilla setup
    #module load gcc/7.3.0
    #module load cuda/10.1.243
    #module load mpich/3.3.1-debug

    # OpenMPI setup
    module load gcc/7.3.0
    module load cuda/10.1.168
    module load openmpi/4.0.1-ucx-1.6

    # Cutting edge mvapich
    #module load gcc/8.2.0
    #module load cuda/10.2.89
    #module load mvapich2/2.3.2

else
    module load gcc/8.2.0
    module unload PrgEnv-intel
    module load PrgEnv-gnu
    module unload craype-hugepages2M
    module unload cray-libsci
    module unload atp
fi

# Setup conda
source /usr/common/software/python/3.7-anaconda-2019.07/etc/profile.d/conda.sh

# Print some stuff
echo "Configuring on $(hostname) as $USER for $SYSTEM_ARCH"
echo "  Build directory $BUILD_DIR"
echo "  Install directory $INSTALL_DIR"
