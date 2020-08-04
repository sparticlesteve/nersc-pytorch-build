#!/bin/bash -e

# Configure the installation
source ./config.sh

# Make a conda env
conda create -y --prefix $INSTALL_DIR python=$PYTHON_VERSION \
    mkl mkl-include numpy pyyaml setuptools cmake cffi typing \
    h5py ipython ipykernel matplotlib scikit-learn pandas pillow

# Install additional packages
conda activate $INSTALL_DIR
conda install -y -c conda-forge ipympl=0.5.6
pip install ray tensorboard tqdm wandb

# Install NERSC tensorboard helper
git clone https://github.com/NERSC/nersc-tensorboard-helper.git \
    $INSTALL_DIR/lib/python${PYTHON_VERSION}/site-packages/nersc-tensorboard-helper

# Install convenient gpustat command
if [[ $SYSTEM_ARCH == "gpu" ]]; then
    pip install gpustat
fi
