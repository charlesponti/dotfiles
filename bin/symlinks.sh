#!/usr/bin/env bash

set -euo pipefail

source "$HOME/.dotfiles/bin/lib.sh"

if [[ -d "$DOTFILES" ]]; then
  informer "Symlinking dotfiles from $DOTFILES"
else
  fail "$DOTFILES does not exist"
fi

link() {
  local from="$1"
  local to="$2"
  
  if ! from_file=$(realpath "$from" 2>/dev/null); then
    echo "Error: Source file '$from' does not exist"
    return 1
  fi
  
  local to_dir
  to_dir=$(dirname "$to")
  if [[ ! -d "$to_dir" ]]; then
    mkdir -p "$to_dir"
  fi
  
  echo "Linking '$from' to '$to'"
  ln -sf "$from_file" "$to"
}

# Symlink all dotfiles from home directory
find "$DOTFILES/home" -maxdepth 1 -name '.*' -type f -print0 | while IFS= read -r -d '' location; do
  file="${location##*/}"
  link "$location" "$HOME/$file"
done

# Also symlink non-hidden files that should be in home
find "$DOTFILES/home" -maxdepth 1 -name '[^.]*' -type f -print0 | while IFS= read -r -d '' location; do
  file="${location##*/}"
  # Skip directories and certain files
  case "$file" in
    "vscode"|"zed") continue ;;
  esac
  link "$location" "$HOME/$file"
done

# ------------------------------------------------------------------------------
# Visual Studio Code
# ------------------------------------------------------------------------------
VSCODE_DST="$HOME/Library/Application Support/Code/User"
VSCODE_SRC="$DOTFILES/home/vscode"

if [[ -d "$VSCODE_SRC" ]]; then
  mkdir -p "$VSCODE_DST"
  link "$VSCODE_SRC/settings.json" "$VSCODE_DST/settings.json"
  link "$VSCODE_SRC/snippets" "$VSCODE_DST/snippets"
fi

# ------------------------------------------------------------------------------
# Zed Editor
# ------------------------------------------------------------------------------
ZED_DST="$HOME/.config/zed"
ZED_SRC="$DOTFILES/home/zed"

if [[ -d "$ZED_SRC" ]]; then
  mkdir -p "$ZED_DST"
  link "$ZED_SRC/settings.json" "$ZED_DST/settings.json"
fi

# ------------------------------------------------------------------------------
# Starship config
# ------------------------------------------------------------------------------
mkdir -p "$XDG_CONFIG_HOME"
link "$DOTFILES/.config/starship.toml" "$XDG_CONFIG_HOME/starship.toml"

success "Symlinking complete"
