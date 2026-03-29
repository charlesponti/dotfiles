#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Guard Resources
# @raycast.mode fullOutput
# @raycast.packageName Dotfiles
# @raycast.icon 🛡️
# @raycast.argument1 { "type": "text", "placeholder": "Max swap GB (default 2.0)", "optional": true }

set -euo pipefail

DOTFILES_ROOT="${DOTFILES:-$HOME/.dotfiles}"
SCRIPT="${DOTFILES_BIN_DIR:-$HOME/bin}/resource-guard.sh"

if [[ ! -x "$SCRIPT" ]]; then
  SCRIPT="$DOTFILES_ROOT/stow/bin/bin/resource-guard.sh"
fi

if [[ ! -x "$SCRIPT" ]]; then
  SCRIPT="$DOTFILES_ROOT/bin/resource-guard.sh"
fi

if [[ ! -x "$SCRIPT" ]]; then
  echo "Missing executable: $SCRIPT"
  echo "Set DOTFILES_BIN_DIR, install the stowed scripts into ~/bin, or keep the repo at ~/.dotfiles."
  exit 1
fi

exec "$SCRIPT" "${1:-2.0}"