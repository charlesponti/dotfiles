#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "Stowing packages..."
stow -v -t ~ -d stow home zsh git tmux starship vim vscode zed bin
