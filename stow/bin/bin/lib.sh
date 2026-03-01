#!/usr/bin/env bash

# Dotfiles location
export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# XDG Defaults
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common functions
source "$SCRIPT_DIR/functions/common/messaging.sh"
source "$SCRIPT_DIR/functions/common/checking.sh"
