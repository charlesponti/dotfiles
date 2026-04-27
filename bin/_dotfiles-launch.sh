#!/bin/bash

dotfiles_exec_script() {
  local script_name="$1"
  shift

  local dotfiles_root="${DOTFILES:-$HOME/.dotfiles}"
  local script="${DOTFILES_BIN_DIR:-$HOME/bin}/$script_name"

  if [[ ! -x "$script" ]]; then
    script="$dotfiles_root/stow/bin/bin/$script_name"
  fi

  if [[ ! -x "$script" ]]; then
    script="$dotfiles_root/bin/$script_name"
  fi

  if [[ ! -x "$script" ]]; then
    echo "Missing executable: $script"
    echo "Set DOTFILES_BIN_DIR, install the stowed scripts into ~/bin, or keep the repo at ~/.dotfiles."
    exit 1
  fi

  exec "$script" "$@"
}
