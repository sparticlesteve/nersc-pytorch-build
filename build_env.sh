#!/bin/bash -e

# Make a conda env
mamba create -y --prefix $INSTALL_DIR python=$PYTHON_VERSION pip \
    astunparse numpy ninja pyyaml mkl mkl-include setuptools cmake cffi \
    typing_extensions future six requests dataclasses h5py ipython ipykernel \
    matplotlib scikit-learn pandas pillow pytables ipympl=0.7.0

# Install additional packages
source $CONDA_INIT_SCRIPT
conda activate $INSTALL_DIR
pip install --no-cache-dir ray tensorboard tqdm wandb ruamel.yaml gpustat pytest \
    git+https://github.com/NERSC/nersc-tensorboard-helper.git
