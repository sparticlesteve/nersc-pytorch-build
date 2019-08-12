#!/bin/bash

# Configure the installation
source ./config.sh

# Make a conda env
conda create -y --prefix $INSTALL_DIR python=3.6 \
    mkl mkl-include numpy pyyaml setuptools cmake cffi typing \
    h5py ipython ipykernel matplotlib scikit-learn pandas

# Installs from other channels
conda activate $INSTALL_DIR
conda install -y -c pytorch magma-cuda101
conda install -y -c conda-forge ipympl
