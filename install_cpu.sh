#!/bin/bash

# Abort on failure
set -e -o pipefail

. config.sh

./checkout_packages.sh
./build_env.sh 2>&1 | tee log.env
conda activate $INSTALL_DIR
./build_pytorch.sh 2>&1 | tee log.pytorch
./build_geometric.sh 2>&1 | tee log.geometric
#./build_craydl.sh 2>&1 | tee log.craydl
./build_mpi4py.sh 2>&1 | tee log.mpi4py
