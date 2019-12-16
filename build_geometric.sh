#!/bin/bash -e

# This script installs PyTorch geometric and its dependencies
# https://github.com/rusty1s/pytorch_geometric

# Configure the installation
source ./config.sh
conda activate $INSTALL_DIR
echo "Building PyTorch Geometric on $(hostname)"

# Install the packages via pip
pip install requests # fixes an import error
pip install --verbose --no-cache-dir torch-scatter
pip install --verbose --no-cache-dir torch-sparse
pip install --verbose --no-cache-dir torch-cluster
pip install --verbose torch-geometric
