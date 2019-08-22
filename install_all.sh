#!/bin/bash

./build_env.sh 2>&1 | tee log.env
./build_pytorch.sh 2>&1 | tee log.pytorch
./build_geometric.sh 2>&1 | tee log.geometric
./build_craydl.sh 2>&1 | tee log.craydl
