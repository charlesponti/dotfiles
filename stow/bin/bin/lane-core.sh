#!/usr/bin/env bash

set -euo pipefail

core_path="$HOME/.local/share/mise/shims:$HOME/.dotfiles/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.local/bin:$HOME/.bun/bin:$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$HOME/bin:/usr/bin:/usr/sbin:/bin:/sbin"

echo "lane-core ready"
echo "To apply in current shell:"
echo "  export PATH=\"$core_path\""
