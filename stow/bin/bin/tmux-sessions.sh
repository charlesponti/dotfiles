#!/usr/bin/env bash
# ======================================================================
# Tmux-sessions loader
# ======================================================================

set -euo pipefail

# configuration
SESSION_NAME="${1:-dev}"
SESSION_TYPE="${2:-}"
WORK_DIR="${3:-$(pwd)}"

# load helpers
# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")/functions/load-all.sh"

main
