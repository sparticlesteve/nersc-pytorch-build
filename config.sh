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
export VISION_VERSION="v0.4.0"
export BUILD_DIR=$SCRATCH/pytorch-build/$INSTALL_NAME/${PYTORCH_VERSION}-gpu
export INSTALL_DIR=$INSTALL_BASE/$INSTALL_NAME/${PYTORCH_VERSION}-gpu

# Setup programming environment
module load gcc/7.3.0
module load cuda/10.1.168 #cuda/10.0.130
module load openmpi/4.0.1-ucx-1.5.2
#openmpi/4.0.1-debug #openmpi/4.0.1-ucx-1.5.2-debug
#openmpi/4.0.1-ucx-1.6 #mvapich2/2.3.2 #openmpi/4.0.1-ucx-1.4
#export MV2_ENABLE_AFFINITY=0

# Setup conda
source /usr/common/software/python/3.7-anaconda-2019.07/etc/profile.d/conda.sh

# Print some stuff
echo "Configuring on $(hostname) as $USER"
echo "  Build directory $BUILD_DIR"
echo "  Install directory $INSTALL_DIR"
