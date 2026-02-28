#!/usr/bin/env bash

set -euo pipefail

cmd="${1:-npm run lint && npm run typecheck}"

if ! command -v watchexec >/dev/null 2>&1; then
  echo "watchexec not installed" >&2
  exit 1
fi

watchexec -e ts,tsx,js,jsx,go,py --debounce 250ms --restart --clear -- zsh -lc "$cmd"
