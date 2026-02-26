#!/usr/bin/env sh
set -eu

profile="${1:-}"
mode="${2:-}" 

if [ -z "$profile" ]; then
  echo "usage: ux-profile.sh <core|power> [--exports]" >&2
  exit 1
fi

case "$profile" in
  core)
    runtime_mode="hybrid"
    ;;
  power)
    runtime_mode="hybrid"
    ;;
  *)
    echo "invalid profile: $profile" >&2
    exit 1
    ;;
esac

if [ "$mode" = "--exports" ]; then
  printf 'export DOTFILES_PROFILE=%s\n' "$profile"
  printf 'export DOTFILES_RUNTIME_MODE=%s\n' "$runtime_mode"
  exit 0
fi

echo "profile: $profile"
echo "runtime_mode: $runtime_mode"
echo "apply with: eval \"$($0 $profile --exports)\""
