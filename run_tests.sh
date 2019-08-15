#!/bin/bash
#SBATCH -C haswell
#SBATCH -N 2
#SBATCH -q debug
#SBATCH -t 5

. config.sh
conda activate $INSTALL_DIR

srun -l -u python test_install.py --mpi --vision --geometric
