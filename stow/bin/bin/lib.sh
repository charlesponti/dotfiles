#!/usr/bin/env bash

# Dotfiles location
export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# XDG Defaults
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Colors
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export NC='\033[0m'

# Messaging functions
informer () {
  printf "\n[ %b..%b ] %s\n" "$BLUE" "$NC" "$1"
}

user () {
  printf "\n[ %b??%b ] %s\n" "$YELLOW" "$NC" "$1"
}

success () {
  printf "\n\r\033[2K  [ %bOK%b ] %s\n" "$GREEN" "$NC" "$1"
}

fail () {
  printf "\n\r\033[2K  [%bFAIL%b] %s\n" "$RED" "$NC" "$1"
  exit 1
}

# Dependency checking
check_cmd() {
  if ! command -v "$1" &> /dev/null; then
    fail "$1 is required but not installed."
  fi
}
