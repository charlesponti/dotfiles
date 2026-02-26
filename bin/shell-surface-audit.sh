#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

errors=0

fail() {
  echo "FAIL: $1"
  errors=$((errors + 1))
}

pass() {
  echo "PASS: $1"
}

required_modules=(
  "system/env.zsh"
  "system/settings.zsh"
  "system/aliases.zsh"
  "system/functions.zsh"
)

for module in "${required_modules[@]}"; do
  if [[ -f "$module" ]]; then
    pass "module present: $module"
  else
    fail "missing module: $module"
  fi
done

mapfile -t exec_files < <(find bin -maxdepth 1 -type f -perm -111 -name '*.sh' -print | sort)
for file in "${exec_files[@]}"; do
  name="$(basename "$file")"
  if rg -Fq "$name" Makefile README.md; then
    pass "entrypoint referenced: $name"
    continue
  fi
  referenced=0
  for other in "${exec_files[@]}"; do
    [[ "$other" == "$file" ]] && continue
    if rg -Fq "$name" "$other"; then
      referenced=1
      break
    fi
  done
  if [[ "$referenced" -eq 1 ]]; then
    pass "entrypoint referenced by script: $name"
  else
    fail "orphan executable entrypoint: $name"
  fi
done

if zsh -i -c 'alias cl >/dev/null && alias gs >/dev/null && alias dc >/dev/null && typeset -f mkcd >/dev/null && typeset -f extract >/dev/null && typeset -f sysinfo >/dev/null'; then
  pass "interactive zsh has required aliases/functions"
else
  fail "interactive zsh missing required aliases/functions"
fi

if [[ "$errors" -gt 0 ]]; then
  echo "shell-surface-audit: $errors failure(s)"
  exit 1
fi

echo "shell-surface-audit: clean"
