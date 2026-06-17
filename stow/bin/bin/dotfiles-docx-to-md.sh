#!/usr/bin/env bash

# @raycast.schemaVersion 1
# @raycast.title Convert Finder DOCX to Markdown
# @raycast.mode fullOutput
# @raycast.packageName Documents
# @raycast.icon 📄
# @raycast.description Convert the current Finder selection from .docx to .md

set -euo pipefail

exec "$HOME/.dotfiles/stow/bin/bin/docx-to-md-selected.sh"
