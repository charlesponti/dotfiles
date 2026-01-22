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
  printf "\n[ ${BLUE}..${NC} ] $1\n"
}

user () {
  printf "\n[ ${YELLOW}??${NC} ] $1\n"
}

success () {
  printf "\n\r\033[2K  [ ${GREEN}OK${NC} ] $1\n"
}

fail () {
  printf "\n\r\033[2K  [${RED}FAIL${NC}] $1\n"
  exit 1
}

# Dependency checking
check_cmd() {
  if ! command -v "$1" &> /dev/null; then
    fail "$1 is required but not installed."
  fi
}
