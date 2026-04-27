#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Dotfiles Status
# @raycast.mode fullOutput
# @raycast.packageName Dotfiles
# @raycast.icon 🧰
# @raycast.argument1 { "type": "dropdown", "placeholder": "View", "data": [ { "title": "Summary", "value": "summary" }, { "title": "Health", "value": "health" }, { "title": "Help", "value": "help" }, { "title": "Dashboard", "value": "dashboard" } ] }

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_dotfiles-launch.sh"

MODE="${1:-summary}"

case "$MODE" in
  summary|health|help|dashboard)
    ;;
  *)
    echo "Unsupported mode: $MODE"
    echo "Expected one of: summary, health, help, dashboard"
    exit 1
    ;;
esac

dotfiles_exec_script status.sh "$MODE"
