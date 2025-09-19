#!/bin/bash
#SBATCH -J pytorch-build
#SBATCH -A nstaff
#SBATCH -C gpu
#SBATCH -q regular
#SBATCH -N 1 -n 1 -G 4 -c 128 -t 4:00:00
#SBATCH -o logs/slurm-build-%j.out

# Abort on failure
set -eo pipefail

# Configuration
export LOG_LEVEL=2
BUILD_STEPS=${BUILD_STEPS:-clean env pytorch extras apex geometric mpi4py}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config/base_config.sh"

# Helper: whether a step needs the environment activated
needs_env_activation() {
    case "$1" in
        clean|env) return 1 ;;  # false => do NOT activate
        *)         return 0 ;;  # true  => activate
    esac
}

# Build step function
build_step() {
    local build="$1"
    local step_script="${SCRIPT_DIR}/builds/build_${build}.sh"

    log_info "Starting build step: $build"

    # Ensure directories exist for logs/artifacts
    mkdir -p "$BUILD_DIR" "$INSTALL_DIR" logs

    # Ensure environment activated for steps that need it
    if needs_env_activation "$build"; then
        activate_environment
    fi

    # Make sure the build step is implemented
    if [[ ! -f "$step_script" ]]; then
        log_error "Build script not found for step '$build': $step_script"
        return 1
    fi

    # Execute the build step
    if bash "$step_script" 2>&1 | tee "logs/build_${build}.log"; then
        log_info "Successfully completed build step: $build"
    else
        log_error "Failed build step: $build"
        return 1
    fi
}

log_info "Starting PyTorch installation"

# Loop over all requested steps
for step in $BUILD_STEPS; do
    build_step "$step"
done

log_info "Installation completed successfully"
