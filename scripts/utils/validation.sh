#!/bin/bash

validate_env_vars() {
    local required_vars=("INSTALL_DIR" "BUILD_DIR" "PYTORCH_VERSION" "PYTHON_VERSION")
    local missing_vars=()

    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            missing_vars+=("$var")
        fi
    done

    if [ ${#missing_vars[@]} -ne 0 ]; then
        log_error "Missing required environment variables: ${missing_vars[*]}"
        return 1
    fi

    return 0
}

validate_dependencies() {
    local deps=("gcc" "g++" "cmake" "git" "conda")
    local missing_deps=()

    for dep in "${deps[@]}"; do
        if ! command -v $dep >/dev/null 2>&1; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        return 1
    fi

    return 0
}
