# Source me

if [ $USER == "swowner" ]; then
    umask 002 # all-readable
    INSTALL_BASE=/usr/common/software
else
    INSTALL_BASE=$SCRATCH/conda
fi

# Configure the installation
export INSTALL_NAME="pytorch"
export PYTORCH_VERSION="v1.2.0"
export PYTORCH_URL=https://github.com/pytorch/pytorch
export VISION_VERSION="v0.3.0"
export BUILD_DIR=$SCRATCH/pytorch-build/$INSTALL_NAME/${PYTORCH_VERSION}-gpu
export INSTALL_DIR=$INSTALL_BASE/$INSTALL_NAME/${PYTORCH_VERSION}-gpu

# Setup programming environment
module load gcc/7.3.0
module load cuda/10.1.168
module load openmpi/4.0.1-ucx-1.6
module unload craype-hugepages2M

# Setup conda
source /usr/common/software/python/3.7-anaconda-2019.07/etc/profile.d/conda.sh

# Print some stuff
echo "Configuring on $(hostname) as $USER"
echo "  Build directory $BUILD_DIR"
echo "  Install directory $INSTALL_DIR"
