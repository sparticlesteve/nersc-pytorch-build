# Source me to setup config for the installations

if [ $USER == "swowner" ]; then
    umask 002 # all-readable
    INSTALL_BASE=/global/common/software/nersc/shasta2105
else
    INSTALL_BASE=$SCRATCH/conda
fi

# Configure the installation
export CPATH=""
export INSTALL_NAME="pytorch"
export PYTHON_VERSION=3.8
export PYTORCH_VERSION="1.9.0"
export PYTORCH_URL=https://github.com/pytorch/pytorch
export VISION_VERSION="0.10.0"
export BUILD_DIR=$SCRATCH/pytorch-build/$INSTALL_NAME/$PYTORCH_VERSION
export INSTALL_DIR=$INSTALL_BASE/$INSTALL_NAME/$PYTORCH_VERSION

# Setup programming environment
module load PrgEnv-gnu
module load cudatoolkit/20.9_11.0 craype-accel-nvidia80
module load nccl/2.9.8
# For CUDA 11.1
#module load nvidia-nersc/20.11

# Setup conda
source /global/common/software/nersc/cos1.3/python/3.8-anaconda-2020.11/etc/profile.d/conda.sh

# Print some stuff
echo "Configuring on $(hostname) as $USER"
echo "  Build directory $BUILD_DIR"
echo "  Install directory $INSTALL_DIR"
