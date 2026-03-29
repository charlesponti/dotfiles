#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_SKIP_DOCTOR=1

exec "$SCRIPT_DIR/status.sh" health