#!/bin/bash -e

# Configure the installation
source ./config.sh

# Make a conda env
conda create -y --prefix $INSTALL_DIR python=$PYTHON_VERSION \
    mkl mkl-include numpy pyyaml setuptools cmake cffi typing \
    h5py ipython ipykernel matplotlib scikit-learn pandas pillow

# Install additional packages
conda activate $INSTALL_DIR
conda install -y -c conda-forge ipympl=0.4.1
pip install ray tensorboard

# Hide the conda-installed ld, which causes problems
# TODO: still needed?
#mv $INSTALL_DIR/compiler_compat/ld $INSTALL_DIR/compiler_compat/backup-ld
