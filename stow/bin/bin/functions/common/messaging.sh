#!/usr/bin/env bash
# Messaging functions for consistent output formatting

# Colors
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export NC='\033[0m'

# Informational message
informer() {
  printf "\n[ %b..%b ] %s\n" "$BLUE" "$NC" "$1"
}

# User query/question message
user() {
  printf "\n[ %b??%b ] %s\n" "$YELLOW" "$NC" "$1"
}

# Success message
success() {
  printf "\n\r\033[2K  [ %bOK%b ] %s\n" "$GREEN" "$NC" "$1"
}

# Failure message and exit
fail() {
  printf "\n\r\033[2K  [%bFAIL%b] %s\n" "$RED" "$NC" "$1"
  exit 1
}

# Logging functions
log_info() {
    echo "[INFO] $*"
}

log_error() {
    echo "[ERROR] $*" >&2
}
