#!/bin/bash

# Download and extract the software
mkdir -p $BUILD_DIR && cd $BUILD_DIR
wget https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.0.3.tar.gz
tar zxvf mpi4py-3.0.3.tar.gz
cd mpi4py-3.0.3

# Build it using the correct MPI wrappers
if [[ $SYSTEM_ARCH == "gpu" ]]; then
    export MPICC=mpicc
else
    export MPICC=cc
    export CRAYPE_LINK_TYPE=dynamic
fi

python setup.py build --mpicc=$MPICC
python setup.py install
