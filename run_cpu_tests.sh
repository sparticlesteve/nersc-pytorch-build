#!/bin/bash
#SBATCH -C haswell
#SBATCH -N 2
#SBATCH -q debug
#SBATCH -t 10
#SBATCH -o slurm-cpu-test-%j.out

. config.sh
conda activate $INSTALL_DIR

# Basic installation tests
srun -l -u python test_install.py --mpi --vision --geometric

# Cray plugin training test - not working
#exampleScript=/opt/cray/pe/craype-dl-plugin-py3/19.06.1/examples/torch_mnist/pytorch_mnist.py
#srun -u -l python $exampleScript --epochs 1 --log-interval 50
