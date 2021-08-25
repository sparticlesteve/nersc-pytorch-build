#!/bin/bash -e
#SBATCH -C haswell
#SBATCH -N 2
#SBATCH -q debug
#SBATCH -t 30
#SBATCH -o slurm-cpu-test-%j.out

# Clone the testing repository
[ -d nersc-pytorch-testing ] || git clone https://github.com/sparticlesteve/nersc-pytorch-testing.git

# Setup software
. config.sh
conda activate $INSTALL_DIR

# Run tests
cd nersc-pytorch-testing

echo "-------------------------------------------------------------------------"
echo "Single node unit tests"
srun -N 1 -n 1 -u python pytorch_info.py
# There seems to be a data race in a cache directory creation if
# some imports from torch-geometric are done in parallel first time.
# So, I do the import tests first in a single process.
srun -N 1 -n 1 -u python test_install.py --vision --geometric

echo "-------------------------------------------------------------------------"
echo "Multi node unit tests"
srun -l -u python test_install.py --mpi #--vision --geometric

echo "-------------------------------------------------------------------------"
echo "DDP MPI training test"
srun -l -u python test_ddp.py --backend mpi

echo "-------------------------------------------------------------------------"
echo "MPI4Py test"
srun -l -u python -m mpi4py.bench helloworld

echo "-------------------------------------------------------------------------"
echo "Single node PyTorch Geometric training test"
srun -N 1 -n 1 -u python test_gcn.py

# Cray plugin training test - not working
#exampleScript=/opt/cray/pe/craype-dl-plugin-py3/19.06.1/examples/torch_mnist/pytorch_mnist.py
#srun -u -l python $exampleScript --epochs 1 --log-interval 50
