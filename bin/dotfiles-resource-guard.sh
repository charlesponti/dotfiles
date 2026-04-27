#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Guard Resources
# @raycast.mode fullOutput
# @raycast.packageName Dotfiles
# @raycast.icon 🛡️
# @raycast.argument1 { "type": "text", "placeholder": "Max swap GB (default 2.0)", "optional": true }

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_dotfiles-launch.sh"

dotfiles_exec_script resource-guard.sh "${1:-2.0}"
