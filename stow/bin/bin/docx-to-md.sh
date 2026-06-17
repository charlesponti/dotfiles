#!/usr/bin/env bash
set -euo pipefail

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

toolbox_dir="${HOME}/Developer/toolbox"

if [[ -x "$toolbox_dir/target/debug/filekit" ]]; then
  exec "$toolbox_dir/target/debug/filekit" docx to-md "$@"
fi

if [[ -x "$toolbox_dir/target/release/filekit" ]]; then
  exec "$toolbox_dir/target/release/filekit" docx to-md "$@"
fi

if command -v cargo >/dev/null 2>&1 && [[ -f "$toolbox_dir/Cargo.toml" ]]; then
  cd "$toolbox_dir"
  exec cargo run -q -p filekit -- docx to-md "$@"
fi

if command -v filekit >/dev/null 2>&1; then
  exec filekit docx to-md "$@"
fi

fail "filekit is not available. Build or install it from $toolbox_dir"
