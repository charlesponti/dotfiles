#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_root="${DOTFILES:-$(cd "$script_dir/.." && pwd)}"

exec "$dotfiles_root/stow/bin/bin/runtime-verify.sh" "$@"