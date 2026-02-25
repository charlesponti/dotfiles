#!/usr/bin/env bash
set -euo pipefail

# Deterministic bootstrap for CI agents.
# Priority: explicit package manager install, then hard fail if unavailable.

if command -v just >/dev/null 2>&1; then
  just --version
  exit 0
fi

if command -v brew >/dev/null 2>&1; then
  brew install just
elif command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y just
elif command -v cargo >/dev/null 2>&1; then
  cargo install just
else
  echo "ERROR: cannot install just (brew/apt/cargo unavailable)" >&2
  exit 1
fi

command -v just >/dev/null 2>&1 || { echo "ERROR: just install failed" >&2; exit 1; }
just --version
