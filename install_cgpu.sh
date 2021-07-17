#!/bin/bash

# Abort on failure
set -e -o pipefail

# Do the full installation for Cori-GPU
source config_cgpu.sh $@

# Build the conda environment
./build_env.sh 2>&1 | tee log.env
conda activate $INSTALL_DIR

# Checkout software packages
./checkout_packages.sh 2>&1 | tee log.checkout

# Build pytorch on a GPU node
srun -C gpu -N 1 -G 1 -c 20 -t 4:00:00 \
    ./build_pytorch.sh 2>&1 | tee log.pytorch

# Build Apex
srun -C gpu -N 1 -G 1 -c 20 -t 30 \
    ./build_apex.sh 2>&1 | tee log.apex

# Build pytorch geometric
srun -C gpu -N 1 -G 1 -c 20 -t 4:00:00 \
    ./build_geometric.sh 2>&1 | tee log.geometric

# Build mpi4py
./build_mpi4py.sh 2>&1 | tee log.mpi4py
