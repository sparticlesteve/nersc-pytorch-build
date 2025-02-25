#!/bin/bash -e

# Consider improving this, e.g. with a yaml specification instead.

# Make a conda env
conda create --prefix $INSTALL_DIR -y python=$PYTHON_VERSION
