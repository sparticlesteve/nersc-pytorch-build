#!/bin/bash -e

# This script installs PyTorch geometric and its dependencies
# https://github.com/rusty1s/pytorch_geometric

echo "Installing PyTorch Geometric"

# Install via conda
mamba install -y pyg -c pyg -c conda-forge
