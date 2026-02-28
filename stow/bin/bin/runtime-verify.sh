#!/usr/bin/env sh
set -eu

fail=0

check_cmd() {
  name="$1"
  if command -v "$name" >/dev/null 2>&1; then
    echo "ok: $name"
  else
    echo "missing: $name"
    fail=1
  fi
}

check_cmd brew
check_cmd nix
check_cmd mise
check_cmd direnv
check_cmd zsh
check_cmd tmux

if [ -f "$HOME/.dotfiles/flake.nix" ]; then
  echo "ok: flake.nix"
else
  echo "missing: flake.nix"
  fail=1
fi

if [ -f "$HOME/.dotfiles/flake.lock" ]; then
  echo "ok: flake.lock"
else
  echo "missing: flake.lock (run: nix flake lock in ~/.dotfiles)"
  fail=1
fi

profile="${DOTFILES_PROFILE:-}"
runtime_mode="${DOTFILES_RUNTIME_MODE:-}"

case "$profile" in
  ''|core|power) : ;;
  *) echo "invalid DOTFILES_PROFILE=$profile"; fail=1 ;;
esac

case "$runtime_mode" in
  ''|hybrid|nix-heavy|brew-heavy) : ;;
  *) echo "invalid DOTFILES_RUNTIME_MODE=$runtime_mode"; fail=1 ;;
esac

if command -v nix >/dev/null 2>&1; then
  if nix flake show "$HOME/.dotfiles" >/dev/null 2>&1; then
    echo "ok: flake evaluation"
  else
    echo "failed: flake evaluation"
    fail=1
  fi
fi

if [ "$fail" -ne 0 ]; then
  exit 1
fi

echo "runtime verification: pass"
