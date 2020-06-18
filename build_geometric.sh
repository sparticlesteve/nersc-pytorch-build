#!/bin/bash -e

# This script installs PyTorch geometric and its dependencies
# https://github.com/rusty1s/pytorch_geometric

# Configure the installation
source ./config.sh
conda activate $INSTALL_DIR
echo "Building PyTorch Geometric"

# Build METIS from source
# Mostly taken from here:
# https://github.com/rusty1s/pytorch_sparse/blob/master/script/metis.sh
cd $BUILD_DIR
METIS=metis-5.1.0
export WITH_METIS=1
wget -nv http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/${METIS}.tar.gz
tar -xvzf ${METIS}.tar.gz
cd ${METIS} || exit
sed -i.bak -e 's/IDXTYPEWIDTH 32/IDXTYPEWIDTH 64/g' include/metis.h
make config prefix=$INSTALL_DIR
make
make install

# Build and install the packages via pip
export CPPFLAGS="-I${INSTALL_DIR}/include"
pip install requests # fixes an import error, do I still need this?
pip install --verbose --no-cache-dir torch-scatter
pip install --verbose --no-cache-dir torch-sparse
pip install --verbose --no-cache-dir torch-cluster
pip install --verbose torch-geometric
