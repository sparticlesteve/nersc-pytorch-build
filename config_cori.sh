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
export PYTORCH_VERSION="1.9.0"
export PYTORCH_URL=https://github.com/pytorch/pytorch
export VISION_VERSION="0.10.0"
export SYSTEM_ARCH=cpu
export BUILD_DIR=$SCRATCH/pytorch-build/$INSTALL_NAME/$PYTORCH_VERSION
export INSTALL_DIR=$INSTALL_BASE/$INSTALL_NAME/$PYTORCH_VERSION

# Setup programming environment
module load gcc/8.3.0
module unload PrgEnv-intel
module load PrgEnv-gnu
module unload craype-hugepages2M
module unload cray-libsci
module unload atp

# Setup conda
export CONDA_INIT_SCRIPT=/usr/common/software/python/3.8-anaconda-2020.11/etc/profile.d/conda.sh
source $CONDA_INIT_SCRIPT

# Print some stuff
echo "Configuring on $(hostname) as $USER for $SYSTEM_ARCH"
echo "  Build directory $BUILD_DIR"
echo "  Install directory $INSTALL_DIR"
