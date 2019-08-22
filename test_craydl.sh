#!/bin/bash
#SBATCH -C haswell
#SBATCH -q debug
#SBATCH -N 2
#SBATCH -t 30

. config.sh
conda activate $INSTALL_DIR
module load craype-dl-plugin-py3/19.06.1

exampleScript=$CRAYPE_ML_PLUGIN_BASEDIR/examples/torch_mnist/pytorch_mnist.py
srun -u -l python $exampleScript
