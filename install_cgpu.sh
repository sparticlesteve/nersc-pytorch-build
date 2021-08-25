#!/bin/bash
#SBATCH -C gpu
#SBATCH -N 1 -n 1 -G 1 -c 20 -t 4:00:00
#SBATCH -o slurm-build-cgpu-%j.out

# Abort on failure
set -e -o pipefail

# Do the full installation for Cori-GPU
source config_cgpu.sh $@

# Build the conda environment
./build_env.sh 2>&1 | tee log.env
conda activate $INSTALL_DIR

# Build PyTorch and the rest
./build_pytorch.sh 2>&1 | tee log.pytorch
./build_apex.sh 2>&1 | tee log.apex
./build_geometric.sh 2>&1 | tee log.geometric
./build_mpi4py.sh 2>&1 | tee log.mpi4py
