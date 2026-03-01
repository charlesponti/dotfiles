#!/usr/bin/env bash
# =============================================================================
# Tmux-init: Auto-launch tmux with intelligent session management
# 
# Purpose: Smart session initialization for Ghostty terminal
# Usage: 
#   tmux-init.sh              # Creates/attaches to 'main' session
#   tmux-init.sh myproject   # Creates/attaches to custom session
#   tmux-init.sh myproject /path/to/dir  # Custom session + directory
#
# Integrates with Ghostty:
#   Add to ~/.config/ghostty/config:
#   command = ~/.dotfiles/bin/tmux-init.sh
# =============================================================================

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source functions
source "$SCRIPT_DIR/functions/common/messaging.sh"
source "$SCRIPT_DIR/functions/tmux-init/session-management.sh"

# Default session name
SESSION_NAME="${1:-main}"

# Default working directory (uses ~/Developer if exists, otherwise ~)
if [[ -d "$HOME/Developer" ]]; then
    DEFAULT_WORK_DIR="$HOME/Developer"
else
    DEFAULT_WORK_DIR="$HOME"
fi

WORK_DIR="${2:-$DEFAULT_WORK_DIR}"

# Tmux socket (allows multiple tmux servers)
TMUX_SOCKET="${TMUX_SOCKET:-}"
TMUX_SOCKET_ARGS=()
if [[ -n "$TMUX_SOCKET" ]]; then
    TMUX_SOCKET_ARGS=(-L "$TMUX_SOCKET")
fi

# -----------------------------------------------------------------------------
# Handle Arguments
# -----------------------------------------------------------------------------

case "${1:-}" in
    -h|--help)
        usage
        exit 0
        ;;
    -v|--version)
        echo "tmux-init version 1.0.0"
        exit 0
        ;;
esac

# Run main function
main
