#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_root="$(cd "$script_dir/../../.." && pwd)"

required_scripts=(
  doctor.sh
  bench-shell.sh
  prompt-bench.sh
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

zsh -f -i -c '
  source "$0/stow/zsh/.zshrc" >/dev/null 2>&1

  required_aliases=(reload path make-dev brun brd)
  for name in "${required_aliases[@]}"; do
    if ! alias "$name" >/dev/null 2>&1; then
      print -u2 "Missing alias: $name"
      exit 1
    fi
  done

  if ! whence -w gcm | grep -q "function"; then
    print -u2 "Missing function: gcm"
    exit 1
  fi
' "$dotfiles_root"

echo "✅ shell surface audit passed"