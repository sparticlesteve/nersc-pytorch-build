#!/bin/bash -e
#SBATCH -C gpu
#SBATCH --gres=gpu:8
#SBATCH --exclusive
#SBATCH -t 30
#SBATCH -o slurm-test-%j.out

# Setup environment
. activate.sh
export LD_LIBRARY_PATH=$INSTALL_DIR/lib/python3.6/site-packages/torch/lib:$LD_LIBRARY_PATH
#export LD_PRELOAD=$MVAPICH2_DIR/lib/libmpi.so

module list
echo $LD_LIBRARY_PATH

echo
echo "----------- TEST 1 node, 1 gpu ------------"
srun -N 1 -n 1 python test_install.py --all

echo
echo "----------- TEST 8 gpus per node ------------"
srun --ntasks-per-node 8 -u -l python test_install.py --all

echo
echo "----------- TEST DistributedDataParallel training ------------"
srun --ntasks-per-node 8 -u -l python test_ddp.py
