#!/bin/bash

# Abort on failure
set -e -o pipefail

# Do the full installation for Cori-GPU
module purge
module load esslurm

# Build the conda environment
./build_env.sh 2>&1 | tee log.env

# Checkout software packages
./checkout_packages.sh 2>&1 | tee log.checkout

# Build pytorch on a GPU node
srun -C gpu -N 1 --gres=gpu:1 -c 40 -t 4:00:00 \
    ./build_pytorch.sh 2>&1 | tee log.pytorch

# Build pytorch geometric
srun -C gpu -N 1 --gres=gpu:1 -c 40 -t 4:00:00 \
    ./build_geometric.sh 2>&1 | tee log.geometric

# Build mpi4py
./build_mpi4py.sh 2>&1 | tee log.mpi4py
