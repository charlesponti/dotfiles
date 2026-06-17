#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: docx-to-md-selected.sh [paths...]

Convert the provided DOCX files/folders to Markdown.
If no paths are provided, use the current Finder selection.
EOF
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

get_finder_selection() {
  osascript <<'APPLESCRIPT'
try
  tell application "Finder"
    set selectedItems to selection
    if (count of selectedItems) is 0 then
      return ""
    end if

    set outputText to ""
    repeat with anItem in selectedItems
      set outputText to outputText & POSIX path of (anItem as alias) & linefeed
    end repeat

    return outputText
  end tell
on error
  return ""
end try
APPLESCRIPT
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

paths=()
if (($# > 0)); then
  paths=("$@")
else
  selection_output="$(get_finder_selection)"
  while IFS= read -r line; do
    [[ -n "$line" ]] && paths+=("$line")
  done <<< "$selection_output"
fi

if ((${#paths[@]} == 0)); then
  fail "No paths provided and Finder selection is empty."
fi

printf 'Converting %d selected path(s)...\n\n' "${#paths[@]}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
exec "$script_dir/docx-to-md" "${paths[@]}"
