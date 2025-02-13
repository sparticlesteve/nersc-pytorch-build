#!/bin/bash
#SBATCH -A nstaff_g
#SBATCH -C gpu
#SBATCH -q regular
#SBATCH -N 1 -n 1 -G 4 -c 128 -t 4:00:00
#SBATCH -o slurm-build-%j.out

# Abort on failure
set -e -o pipefail

# Use local modulefiles
module use /global/homes/s/sfarrell/WorkAreas/software/modulefiles/src

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/scripts/utils/logging.sh"

# Setup logging
export LOG_LEVEL=2
log_info "Starting PyTorch installation"

# Source configuration
source "${SCRIPT_DIR}/scripts/config/base_config.sh"

# Clean any previous install
# TODO: find a safer and more flexible way to do this (reuse when desired).
./clean.sh

# Create required directories
mkdir -p "$BUILD_DIR" "$INSTALL_DIR" logs

# Build the conda environment
# Consider revamping this to be a yaml file or something
log_info "Starting build of base environment"
${SCRIPT_DIR}/builds/build_env.sh 2>&1 | tee logs/build_env.log
conda activate $INSTALL_DIR

# Build the rest in order
builds=(
    "pytorch"
    "apex"
    "geometric"
    "mpi4py"
)

# Make this a function
for build in "${builds[@]}"; do
    log_info "Starting build of $build"
    if "${SCRIPT_DIR}/builds/build_${build}.sh" 2>&1 | tee "logs/build_${build}.log"; then
        log_info "Successfully completed build of $build"
    else
        log_error "Failed to build $build"
        exit 1
    fi
done

log_info "Installation completed successfully"
