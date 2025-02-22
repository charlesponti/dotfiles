#!/usr/bin/env bash

set -euo pipefail

dotfiles="$HOME/.dotfiles"

if [[ -d "$dotfiles" ]]; then
  echo "Symlinking dotfiles from $dotfiles"
else
  echo "$dotfiles does not exist"
  exit 1
fi

link() {
  if ! from_file=$(realpath "$1" 2>/dev/null); then
    echo "Error: Source file '$1' does not exist"
    return 1
  fi
  
  to_dir=$(dirname "$2")
  if [[ ! -d "$to_dir" ]]; then
    mkdir -p "$to_dir"
  fi
  
  echo "Linking '$1' to '$2'"
  ln -sf "$from_file" "$2"
}

for location in $(find "$HOME/.dotfiles/home" -name '.*'); do
  file="${location##*/}"
  file="${file%.sh}"
  link "$location" "$HOME/$file"
done

# ------------------------------------------------------------------------------
# Visual Studio Code
# ------------------------------------------------------------------------------
VSCODE="$HOME/Library/Application Support/Code/User"
VSCODE_BIN="$dotfiles/home/vscode"

if [[ ! -d "$VSCODE_BIN" ]]; then
  echo "VSCode config directory not found at $VSCODE_BIN"
  exit 1
fi

# Create VSCode config directory if it doesn't exist
mkdir -p "$VSCODE"

# Symlink VSCode settings
link "$VSCODE_BIN/settings.json" "$VSCODE/settings.json"
link "$VSCODE_BIN/snippets" "$VSCODE/snippets"