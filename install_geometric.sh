#!/bin/bash -e

# This script installs PyTorch geometric and its dependencies
# https://github.com/rusty1s/pytorch_geometric

# Configure the installation
source ./config.sh
conda activate $INSTALL_DIR
echo "Installing PyTorch Geometric"

# TODO: figure out how to enable METIS here

# To install the pytorch geometric wheels, need to identify correct URL
if [[ $CUDA_VERSION == "10.2.89" ]]; then
    wheelURL=https://pytorch-geometric.com/whl/torch-${PYTORCH_VERSION}+cu102.html
else
    echo "Problem resolving pytorch-geometric url with cuda $CUDA_VERSION"
    exit 1
fi

# Install the pytorch geometric binaries
pip install torch-scatter -f $wheelURL
pip install torch-sparse -f $wheelURL
pip install torch-cluster -f $wheelURL
pip install torch-geometric
