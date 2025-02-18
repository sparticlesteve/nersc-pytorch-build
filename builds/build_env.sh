#!/bin/bash -e

# Consider improving this, e.g. with a yaml specification instead.

# Make a conda env
conda create --prefix $INSTALL_DIR -y python=$PYTHON_VERSION

#conda create --prefix $INSTALL_DIR -y -c nvidia -c conda-forge -c pytorch \
#    python=$PYTHON_VERSION ninja pyyaml \
#    cuda=${CUDA_VERSION} cudnn magma-cuda${CUDA_VERSION/./} \
#    libpng libjpeg-turbo

#mamba create -y --prefix $INSTALL_DIR python=$PYTHON_VERSION pip \
#    astunparse numpy ninja pyyaml mkl mkl-include setuptools cffi pybind11 \
#    typing_extensions future six requests dataclasses h5py ipython ipykernel \
#    matplotlib scikit-learn pandas pillow pytables ipympl sympy \
#    libgcc-ng=13 libstdcxx-ng=13 # avoids conflicts with gcc-native/12.3
#
## Install additional packages
## FIXME: this installs torch and cuda packages, which we don't want.
#module load conda
#conda activate $INSTALL_DIR
#pip install --no-cache-dir ray ray[tune] tensorboard tqdm wandb ruamel.yaml \
#    accelerate datasets evaluate transformers \
#    gpustat pytest opencv-python scikit-image torch_tb_profiler \
#    git+https://github.com/NERSC/nersc-tensorboard-helper.git
#
## Remove conda ld which causes problems
#rm $INSTALL_DIR/compiler_compat/ld
