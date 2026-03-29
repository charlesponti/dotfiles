#!/usr/bin/env bash
set -euo pipefail

runs="${1:-30}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

exec "$script_dir/bench-shell.sh" --runs "$runs" --budget-ms 0 --label "prompt startup"