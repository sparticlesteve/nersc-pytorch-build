#!/bin/bash
#SBATCH -C haswell
#SBATCH -N 2
#SBATCH -q debug
#SBATCH -t 10

. ../config.sh
conda activate $INSTALL_DIR

srun python test_mpi.py
