#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Maintain Tmux
# @raycast.mode fullOutput
# @raycast.packageName Dotfiles
# @raycast.icon 🧱

set -euo pipefail

DOTFILES_ROOT="${DOTFILES:-$HOME/.dotfiles}"
SCRIPT="${DOTFILES_BIN_DIR:-$HOME/bin}/tmux-maintain.sh"

if [[ ! -x "$SCRIPT" ]]; then
  SCRIPT="$DOTFILES_ROOT/stow/bin/bin/tmux-maintain.sh"
fi

if [[ ! -x "$SCRIPT" ]]; then
  SCRIPT="$DOTFILES_ROOT/bin/tmux-maintain.sh"
fi

if [[ ! -x "$SCRIPT" ]]; then
  echo "Missing executable: $SCRIPT"
  echo "Set DOTFILES_BIN_DIR, install the stowed scripts into ~/bin, or keep the repo at ~/.dotfiles."
  exit 1
fi

exec "$SCRIPT"