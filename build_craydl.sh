#!/bin/bash -e
#
# Install the Cray DL plugin.
#
# We use the wheel installation method for builds with gcc >= 4.9 and c++11 ABI.
#
# See the documentation here:
#   /opt/cray/pe/craype-dl-plugin-py3/20.06.1/wheel/README
#

# Load the cray plugin module
module load craype-dl-plugin-py3/20.06.1

# Install the wheel
pip install $CRAYPE_ML_PLUGIN_BASEDIR/wheel/dl_comm-20.6.1.tar.gz
#pip install /project/projectdirs/nstaff/swowner/craype-dl-plugin/dl_comm-19.6.1.tar.gz
