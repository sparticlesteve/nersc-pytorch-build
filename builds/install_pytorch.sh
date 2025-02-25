#!/bin/bash -e

# Install PyTorch, torchvision, and cuda via conda
mamba install -y -c pytorch -c nvidia \
    pytorch=$PYTORCH_VERSION torchvision=$VISION_VERSION cudatoolkit=${CUDA_VERSION:0:4}
