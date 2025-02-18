#!/bin/bash -e

# TODO: move these into a requirements file
pip install --no-cache-dir -v --upgrade \
    --extra-index-url https://developer.download.nvidia.com/compute/redist \
    lightning ray ray[tune] tensorboard pybind11 pyyaml h5py ipython ipykernel \
    matplotlib scikit-learn pandas pillow tables ipympl sympy tqdm wandb \
    accelerate datasets evaluate transformers gpustat pytest opencv-python \
    scikit-image torch_tb_profiler nvidia-dali-cuda120 \
    git+https://github.com/NERSC/nersc-tensorboard-helper.git

# NVIDIA DALI library for accelerated I/O
#pip install --no-cache-dir -v --extra-index-url https://developer.download.nvidia.com/compute/redist --upgrade nvidia-dali-cuda120
