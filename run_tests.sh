#!/bin/bash -e
#SBATCH -C gpu
#SBATCH -N 2
#SBATCH --ntasks-per-node 4
#SBATCH --gpus-per-node 4
#SBATCH --cpus-per-task 32
#SBATCH -t 30
#SBATCH -o slurm-gpu-test-%j.out

# Clone the testing repository
[ -d nersc-pytorch-testing ] || git clone https://github.com/sparticlesteve/nersc-pytorch-testing.git

# Use local modulefiles
module use /global/homes/s/sfarrell/WorkAreas/software/modulefiles/src

# Setup software
source ./config/base_config.sh
activate_environment

# Run tests
cd nersc-pytorch-testing
./scripts/run_gpu_tests.sh
