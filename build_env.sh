#!/bin/bash -e

# Make a conda env
mamba create -y --prefix $INSTALL_DIR python=$PYTHON_VERSION pip \
    ninja mkl mkl-include numpy pyyaml setuptools cmake cffi typing \
    h5py ipython ipykernel matplotlib scikit-learn pandas pillow pytables

# Install additional packages
conda activate $INSTALL_DIR
mamba install -y -c conda-forge ipympl=0.7.0
pip install --no-cache-dir ray tensorboard tqdm wandb ruamel.yaml gpustat \
    git+https://github.com/NERSC/nersc-tensorboard-helper.git
