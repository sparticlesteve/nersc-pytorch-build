#!/bin/bash -e

. activate.sh
module load esslurm

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
    --ntasks-per-node 16 -c 10 -t 5 -u -l \
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

# Multi-node NCCL fails
#srun -C gpu -N 2 --gres=gpu:8 --exclusive \
#    --ntasks-per-node 8 -c 10 -t 5 -u -l \
#    python test_ddp.py --backend nccl-file

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
