#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Dotfiles Status
# @raycast.mode fullOutput
# @raycast.packageName Dotfiles
# @raycast.icon 🧰
# @raycast.argument1 { "type": "dropdown", "placeholder": "View", "data": [ { "title": "Summary", "value": "summary" }, { "title": "Health", "value": "health" }, { "title": "Help", "value": "help" }, { "title": "Dashboard", "value": "dashboard" } ] }

set -euo pipefail

DOTFILES_ROOT="${DOTFILES:-$HOME/.dotfiles}"
SCRIPT="${DOTFILES_BIN_DIR:-$HOME/bin}/status.sh"
MODE="${1:-summary}"

if [[ ! -x "$SCRIPT" ]]; then
  SCRIPT="$DOTFILES_ROOT/stow/bin/bin/status.sh"
fi

if [[ ! -x "$SCRIPT" ]]; then
  SCRIPT="$DOTFILES_ROOT/bin/status.sh"
fi

if [[ ! -x "$SCRIPT" ]]; then
  echo "Missing executable: $SCRIPT"
  echo "Set DOTFILES_BIN_DIR, install the stowed scripts into ~/bin, or keep the repo at ~/.dotfiles."
  exit 1
fi

case "$MODE" in
  summary|health|help|dashboard)
    ;;
  *)
    echo "Unsupported mode: $MODE"
    echo "Expected one of: summary, health, help, dashboard"
    exit 1
    ;;
esac

exec "$SCRIPT" "$MODE"