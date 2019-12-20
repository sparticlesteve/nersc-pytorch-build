#!/bin/bash -e

. activate.sh

echo "-------------------------------------------------------------------------"
echo "Single GPU unit tests"
srun -C gpu -N 1 --gres=gpu:8 -c 10 -t 5 -u python test_install.py --all

echo "-------------------------------------------------------------------------"
echo "Multi GPU unit tests"
srun -C gpu -N 1 --gres=gpu:8 --exclusive \
    --ntasks-per-node 8 -c 10 -t 5 -u -l \
    python test_install.py --all

echo "-------------------------------------------------------------------------"
echo "Multi node, multi GPU unit tests"
srun -C gpu -N 2 --gres=gpu:8 --exclusive \
    --ntasks-per-node 8 -c 10 -t 5 -u -l \
    python test_install.py --all

echo "-------------------------------------------------------------------------"
echo "DDP NCCL training test"
srun -C gpu -N 1 --gres=gpu:8 --exclusive \
    --ntasks-per-node 8 -c 10 -t 5 -u -l \
    python test_ddp.py --backend nccl-file

echo "-------------------------------------------------------------------------"
echo "DDP MPI training test"
srun -C gpu -N 1 --gres=gpu:8 --exclusive \
    --ntasks-per-node 8 -c 10 -t 5 -u -l \
    python test_ddp.py --backend mpi

echo "-------------------------------------------------------------------------"
echo "DDP Gloo training test"
srun -C gpu -N 1 --gres=gpu:8 --exclusive \
    --ntasks-per-node 8 -c 10 -t 5 -u -l \
    python test_ddp.py --backend gloo-file

echo "-------------------------------------------------------------------------"
echo "DDP Gloo multi-node training test"
srun -C gpu -N 2 --gres=gpu:8 --exclusive \
    --ntasks-per-node 8 -c 10 -t 5 -u -l \
    python test_ddp.py --backend gloo-file

# Multi-node NCCL fails
echo "-------------------------------------------------------------------------"
echo "DDP NCCL multi-node training test"
#export NCCL_DEBUG=INFO
#export NCCL_DEBUG_SUBSYS=ALL
srun -C gpu -N 2 --gres=gpu:8 --exclusive \
    --ntasks-per-node 8 -c 10 -t 5 -u -l \
    python test_ddp.py --backend nccl-file
