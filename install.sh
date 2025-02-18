#!/bin/bash
#SBATCH -A nstaff_g
#SBATCH -C gpu
#SBATCH -q regular
#SBATCH -N 1 -n 1 -G 4 -c 128 -t 4:00:00
#SBATCH -o slurm-build-%j.out

# Abort on failure
set -eo pipefail

# Use local modulefiles
module use /global/homes/s/sfarrell/WorkAreas/software/modulefiles/src

# Source configuration and utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LOG_LEVEL=2
source "${SCRIPT_DIR}/config/base_config.sh"

log_info "Starting PyTorch installation"

# Build step function
build_step() {
    local build="$1"
    log_info "Starting build of $build"
    if "${SCRIPT_DIR}/builds/build_${build}.sh" 2>&1 | tee "logs/build_${build}.log"; then
        log_info "Successfully completed build of $build"
    else
        log_error "Failed to build $build"
        return 1
    fi
}

# Clean any previous install
if ${CLEAN_INSTALL:-false}; then
    log_info "Cleaning up any previous installation artifacts"
    ${SCRIPT_DIR}/clean.sh
fi

# Create required directories
mkdir -p "$BUILD_DIR" "$INSTALL_DIR" logs

# Build the base conda environment
if ${BUILD_ENV:-false}; then
    build_step env
fi
log_info "Activating environment"
activate_environment
log_info "Done activating environment"

# Build pytorch and the rest
if ${BUILD_PYTORCH:-false}; then
    build_step pytorch
fi
if ${BUILD_EXTRAS:-false}; then
    build_step extras
fi
if ${BUILD_APEX:-true}; then
    build_step apex
fi
if ${BUILD_GEOMETRIC:-true}; then
    build_step geometric
fi
if ${BUILD_MPI4PY:-true}; then
    build_step mpi4py
fi

log_info "Installation completed successfully"
