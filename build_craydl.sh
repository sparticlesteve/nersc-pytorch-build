#!/bin/bash
#
# Install the Cray DL plugin.
#
# We use the wheel installation method for builds with gcc >= 4.9 and c++11 ABI.
#
# See the documentation here:
#   /opt/cray/pe/craype-dl-plugin-py3/19.06.1/wheel/README
#

# Setup our installation
source activate.sh

# Load the cray plugin module
module load craype-dl-plugin-py3/19.06.1

# The tarball wheel file there is broken; install this fixed one
pip install /project/projectdirs/nstaff/swowner/craype-dl-plugin/dl_comm-19.6.1.tar.gz
