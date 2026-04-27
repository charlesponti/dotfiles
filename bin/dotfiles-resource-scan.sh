#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Scan Resources
# @raycast.mode fullOutput
# @raycast.packageName Dotfiles
# @raycast.icon 🔎

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_dotfiles-launch.sh"

dotfiles_exec_script resource-scan.sh
