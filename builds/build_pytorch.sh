#!/bin/bash -e

# Install pytorch, torchvision, and cuda all via pip
pip install --no-cache-dir torch==$PYTORCH_VERSION torchvision $PYTORCH_INSTALL_OPTS
