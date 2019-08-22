#!/bin/bash
#
# Install the Cray DL plugin.
#
# We use the wheel installation method for builds with gcc >= 4.9 and c++11 ABI.
#
# See the documentation here:
#   /opt/cray/pe/craype-dl-plugin-py3/19.06.1/wheel/README
#

source activate.sh
module load craype-dl-plugin-py3/19.06.1
# Testing Kristi's "fixed" wheel
pip install /global/cscratch1/sd/kristyn/plugin_rpms/dl_comm-19.6.1.tar.gz
#pip install $CRAYPE_ML_PLUGIN_BASEDIR/wheel/dl_comm-19.6.1.tar.gz
