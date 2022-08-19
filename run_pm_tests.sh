#!/bin/bash -e
#SBATCH -A nstaff_g
#SBATCH -C gpu
#SBATCH -N 2
#SBATCH --ntasks-per-node 4
#SBATCH --gpus-per-node 4
#SBATCH -c 32
#SBATCH -t 30
#SBATCH -o slurm-gpu-test-%j.out

# Clone the testing repository
[ -d nersc-pytorch-testing ] || git clone https://github.com/sparticlesteve/nersc-pytorch-testing.git

# Setup software
. config.sh
conda activate $INSTALL_DIR

# Run tests
cd nersc-pytorch-testing
./scripts/run_gpu_tests.sh

#echo "-------------------------------------------------------------------------"
#echo "Single GPU unit tests"
#srun -N 1 -n 1 -u python pytorch_info.py
#srun -N 1 -n 1 -u python test_install.py --cuda --vision --geometric
#
##echo "-------------------------------------------------------------------------"
##echo "Multi GPU unit tests"
##srun --ntasks-per-node 8 -u -l python test_install.py --mpi --cuda
#
#echo "-------------------------------------------------------------------------"
#echo "DDP NCCL training test"
##export NCCL_DEBUG=INFO
##export NCCL_DEBUG_SUBSYS=ALL
#srun -u -l python test_ddp.py --gpu --backend nccl --init-method slurm \
#    --ranks-per-node=$SLURM_NTASKS_PER_NODE
#
## Disabling failing MPI test
##echo "-------------------------------------------------------------------------"
##echo "DDP MPI training test"
##export MPICH_GPU_SUPPORT_ENABLED=1
##srun -u -l python test_ddp.py --gpu --backend mpi --init-method slurm
#
#echo "-------------------------------------------------------------------------"
#echo "DDP Gloo training test"
#srun -u -l python test_ddp.py --gpu --backend gloo --init-method slurm \
#    --ranks-per-node=$SLURM_NTASKS_PER_NODE
#
#echo "-------------------------------------------------------------------------"
#echo "PyTorch Geometric training test"
#srun -n 1 -u python test_gcn.py
#
#echo "-------------------------------------------------------------------------"
#echo "MPI4Py test"
#srun -l -u python -m mpi4py.bench helloworld
