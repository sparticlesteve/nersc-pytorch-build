#!/bin/bash

# Abort on failure
set -e -o pipefail

# Do the full installation for Cori-GPU
module purge
module load cgpu

# Build the conda environment
./build_env.sh 2>&1 | tee log.env

# Checkout software packages
#./checkout_packages.sh 2>&1 | tee log.checkout

# Install pytorch on a gpu node
srun -C gpu -N 1 -G 1 -c 10 -t 10 ./install_pytorch.sh 2>&1 | tee log.pytorch

# Build pytorch on a GPU node
#srun -C gpu -N 1 --gres=gpu:1 -c 40 -t 4:00:00 \
#    ./build_pytorch.sh 2>&1 | tee log.pytorch

# Build pytorch geometric
#srun -C gpu -N 1 --gres=gpu:1 -c 40 -t 4:00:00 \
#    ./build_geometric.sh 2>&1 | tee log.geometric

# Build mpi4py
#./build_mpi4py.sh 2>&1 | tee log.mpi4py
