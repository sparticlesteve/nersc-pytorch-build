#!/bin/bash

set -e
./build_env.sh 2>&1 | tee build_env.log
./build_pytorch.sh 2>&1 | tee build_pytorch.log
./build_geometric.sh 2>&1 | tee build_geometric.log
