#!/bin/bash
#SBATCH -C gpu
#SBATCH -N 1
#SBATCH --gres=gpu:8
#SBATCH --exclusive
#SBATCH -t 4:00:00
#SBATCH -o slurm-build-%j.out

set -e

echo "-------Building conda environment-------"
srun -n 1 ./build_env.sh

echo
echo "-------Building pytorch-------"
srun -n 1 ./build_pytorch.sh

echo
echo "-------Building pytorch-geometric-------"
srun -n 1 ./build_geometric.sh

echo "-------DONE-------"
