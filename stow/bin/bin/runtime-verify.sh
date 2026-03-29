#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_root="$(cd "$script_dir/../../.." && pwd)"

required_scripts=(
  bench-shell.sh
  runtime-verify.sh
  shell-surface-audit.sh
  status.sh
  shell-maintain.sh
  tmux-maintain.sh
  resource-scan.sh
  resource-guard.sh
)

for script in "${required_scripts[@]}"; do
  if [[ ! -x "$script_dir/$script" ]]; then
    echo "Missing executable: $script_dir/$script" >&2
    exit 1
  fi
done

zsh -n "$dotfiles_root/stow/zsh/.zshrc"
zsh -n "$dotfiles_root/stow/zsh/system/env.zsh"
zsh -n "$dotfiles_root/stow/zsh/system/settings.zsh"
zsh -n "$dotfiles_root/stow/zsh/system/aliases.zsh"

if command -v tmux >/dev/null 2>&1; then
  tmux -L dotfiles-verify -f "$dotfiles_root/stow/tmux/.tmux.conf" new-session -d >/dev/null 2>&1
  tmux -L dotfiles-verify kill-server >/dev/null 2>&1 || true
fi

echo "✅ runtime verification passed"