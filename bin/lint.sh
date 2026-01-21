#!/usr/bin/env bash
# Lint shell scripts in the repository
# Usage: ./bin/lint.sh

set -euo pipefail

# Load library
source "$(dirname "$0")/lib.sh"

informer "🔍 Running ShellCheck on all .sh files..."

if ! command -v shellcheck &> /dev/null; then
  fail "shellcheck is not installed. Run 'brew install shellcheck' or 'make install'."
fi

# Find all shell files and run shellcheck
# We ignore SC1090/SC1091 because we dynamic source our lib.sh
errors=0
while IFS= read -r -d '' file; do
  if ! shellcheck -x -e SC1090,SC1091 "$file"; then
    errors=$((errors + 1))
  fi
done < <(find . -type f -name "*.sh" -not -path "./.git/*" -print0)

if [ "$errors" -eq 0 ]; then
  success "All shell scripts passed linting!"
else
  fail "$errors script(s) failed linting. Please fix the errors above."
fi
