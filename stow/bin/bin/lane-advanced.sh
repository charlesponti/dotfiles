#!/usr/bin/env bash

set -euo pipefail

base="$HOME/.local/share/mise/shims:$HOME/.dotfiles/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.local/bin:$HOME/.bun/bin:$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$HOME/bin:/usr/bin:/usr/sbin:/bin:/sbin"
advanced=""
for candidate in "$HOME/.ollama/bin" "/opt/homebrew/opt/llvm/bin" "/opt/homebrew/opt/openjdk/bin"; do
  if [[ -d "$candidate" ]]; then
    if [[ -n "$advanced" ]]; then
      advanced+="${candidate}:"
    else
      advanced="${candidate}:"
    fi
  fi
done

new_path="${advanced}${base}"
echo "lane-advanced ready"
echo "To apply in current shell:"
echo "  export PATH=\"$new_path\""
