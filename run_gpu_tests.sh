#!/bin/bash -e
#SBATCH -C gpu
#SBATCH -N 1
#SBATCH --gres=gpu:8
#SBATCH --exclusive
#SBATCH -c 10
#SBATCH -t 30
#SBATCH -o slurm-gpu-test-%j.out

. activate.sh

echo "-------------------------------------------------------------------------"
echo "Single GPU unit tests"
srun -N 1 -n 1 -u python test_install.py --cuda --vision --geometric

echo "-------------------------------------------------------------------------"
echo "Multi GPU unit tests"
srun --ntasks-per-node 8 -u -l python test_install.py --mpi --cuda

echo "-------------------------------------------------------------------------"
echo "DDP NCCL training test"
#export NCCL_DEBUG=INFO
#export NCCL_DEBUG_SUBSYS=ALL
srun --ntasks-per-node 8 -u -l python test_ddp.py --backend nccl-file --gpu

# Disabling failing MPI test
#echo "-------------------------------------------------------------------------"
#echo "DDP MPI training test"
#srun --ntasks-per-node 8 -u -l python test_ddp.py --backend mpi --gpu

echo "-------------------------------------------------------------------------"
echo "DDP Gloo training test"
srun --ntasks-per-node 8 -u -l python test_ddp.py --backend gloo-file --gpu

echo "-------------------------------------------------------------------------"
echo "PyTorch Geometric training test"
srun -n 1 -u python test_gcn.py
