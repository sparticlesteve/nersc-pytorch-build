#!/bin/bash -e

# Make a conda env
mamba create -y --prefix $INSTALL_DIR python=$PYTHON_VERSION pip \
    astunparse numpy ninja pyyaml mkl mkl-include setuptools cffi \
    typing_extensions future six requests dataclasses h5py ipython ipykernel \
    matplotlib scikit-learn pandas pillow pytables ipympl

# Install additional packages
source $CONDA_INIT_SCRIPT
conda activate $INSTALL_DIR
pip install --no-cache-dir ray tensorboard tqdm wandb ruamel.yaml gpustat \
    pytest opencv-python scikit-image \
    git+https://github.com/NERSC/nersc-tensorboard-helper.git \
    torch_tb_profiler

# Remove conda ld which causes problems
rm $INSTALL_DIR/compiler_compat/ld
