# Source me

if [ $USER == "swowner" ]; then
    umask 002 # all-readable
    INSTALL_BASE=/usr/common/software
else
    INSTALL_BASE=$SCRATCH/conda
fi

# Configure the installation
export INSTALL_NAME="pytorch"
export PYTORCH_VERSION="v1.1.0"
export PYTORCH_URL=https://github.com/pytorch/pytorch
export VISION_VERSION="v0.2.2"
export BUILD_DIR=$SCRATCH/pytorch-build/$INSTALL_NAME/$PYTORCH_VERSION
export INSTALL_DIR=$INSTALL_BASE/$INSTALL_NAME/$PYTORCH_VERSION

# Setup programming environment
module unload PrgEnv-intel
module load PrgEnv-gnu

# Setup conda
source /usr/common/software/python/3.6-anaconda-5.2/etc/profile.d/conda.sh

# Print some stuff
echo "Installing on $(hostname) as $USER"
echo "  Build directory $BUILD_DIR"
echo "  Install directory $INSTALL_DIR"
