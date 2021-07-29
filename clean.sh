#!/bin/bash
set -e
clean="rm -rf $BUILD_DIR $INSTALL_DIR"
echo "Running $clean"
sleep 5s
$clean
