#!/usr/bin/env bash
# wrapper for tmux session management
# this script is called directly by login/ghostty and delegates
# to the real implementation under stow/bin/bin/functions/tmux-init.

set -euo pipefail

# determine where the repository lives; allow override via DOTFILES
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# location of helper scripts inside the repo
SCRIPT_DIR="$DOTFILES/stow/bin/bin"

# load shared library (defines log_info/log_error, etc)
source "$SCRIPT_DIR/lib.sh"

# load the session management functions
source "$SCRIPT_DIR/functions/tmux-init/session-management.sh"

# execute the main entrypoint from the sourced script
main "$@"
