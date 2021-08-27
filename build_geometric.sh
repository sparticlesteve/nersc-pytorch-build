#!/bin/bash -e

# This script installs PyTorch geometric and its dependencies
# https://github.com/rusty1s/pytorch_geometric

echo "Building PyTorch Geometric"

# Drop the cray compiler wrappers, they aren't currently working here.
export CXX=g++
export CC=gcc
# Add sdk math_libs include path to find headers like cusparse.h
export CPATH=/opt/nvidia/hpc_sdk/Linux_x86_64/20.9/math_libs/11.0/include:$CPATH
# Add lib paths to LIBRARY_PATH so linker can find them
export LIBRARY_PATH=$LD_LIBRARY_PATH
cd $BUILD_DIR


# Build METIS from source
# Mostly taken from here:
# https://github.com/rusty1s/pytorch_sparse/blob/master/script/metis.sh
METIS=metis-5.1.0
export WITH_METIS=1
wget -nv http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/${METIS}.tar.gz
tar -xvzf ${METIS}.tar.gz
cd ${METIS} || exit
sed -i.bak -e 's/IDXTYPEWIDTH 32/IDXTYPEWIDTH 64/g' include/metis.h
make config prefix=$INSTALL_DIR cc=gcc
nice make -j
make install

# Build and install the packages via pip
export CPPFLAGS="-I${INSTALL_DIR}/include"
#pip install requests # fixes an import error, do I still need this?
pip install --verbose --no-cache-dir torch-scatter
pip install --verbose --no-cache-dir torch-sparse
pip install --verbose --no-cache-dir torch-cluster
pip install --verbose torch-geometric

# Install master versions directly from github (sometimes needed)
#pip install --verbose --no-cache-dir git+https://github.com/rusty1s/pytorch_scatter.git
#pip install --verbose --no-cache-dir git+https://github.com/rusty1s/pytorch_sparse.git
#pip install --verbose --no-cache-dir git+https://github.com/rusty1s/pytorch_cluster.git
#pip install --verbose --no-cache-dir git+https://github.com/rusty1s/pytorch_geometric.git
