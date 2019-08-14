#!/bin/bash -e

. activate.sh
module load esslurm

# 1 node, 1 gpu
srun -C gpu -N 1 --gres=gpu:8 -c 10 -t 5 -u python test_install.py --all

# 1 node, 8 ranks
srun -C gpu -N 1 --gres=gpu:8 --exclusive \
    -n 8 -c 10 -t 5 -u -l \
    python test_install.py --all

# 2 nodes, 16 ranks
srun -C gpu -N 2 --gres=gpu:8 --exclusive \
    -n 16 -c 10 -t 5 -u -l \
    python test_install.py --all
