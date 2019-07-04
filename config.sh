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
export BUILD_DIR=$SCRATCH/pytorch-build/$INSTALL_NAME/${PYTORCH_VERSION}-gpu
export INSTALL_DIR=$INSTALL_BASE/$INSTALL_NAME/${PYTORCH_VERSION}-gpu

# Setup programming environment
module load gcc/7.3.0
module load cuda/10.0
module load nccl/2.4.2
module load openmpi/3.1.0-ucx

# Setup conda
source /usr/common/software/python/3.6-anaconda-5.2/etc/profile.d/conda.sh

# Print some stuff
echo "Configuring on $(hostname) as $USER"
echo "  Build directory $BUILD_DIR"
echo "  Install directory $INSTALL_DIR"
