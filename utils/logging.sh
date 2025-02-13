#!/bin/bash

# Log levels
LOG_ERROR=0
LOG_WARN=1
LOG_INFO=2
LOG_DEBUG=3

# Default to INFO
CURRENT_LOG_LEVEL=${LOG_LEVEL:-2}

log() {
    local level=$1
    shift
    local msg="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    if [ $level -le $CURRENT_LOG_LEVEL ]; then
        case $level in
            0) echo "[$timestamp] ERROR: $msg" ;;
            1) echo "[$timestamp] WARN:  $msg" ;;
            2) echo "[$timestamp] INFO:  $msg" ;;
            3) echo "[$timestamp] DEBUG: $msg" ;;
        esac
    fi
}

log_error() { log $LOG_ERROR "$@"; }
log_warn() { log $LOG_WARN "$@"; }
log_info() { log $LOG_INFO "$@"; }
log_debug() { log $LOG_DEBUG "$@"; }
