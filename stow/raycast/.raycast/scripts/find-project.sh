#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Find Project
# @raycast.mode silent
# @raycast.packageName Dev

PROJECT=$(find ~/projects -maxdepth 1 -type d | fzf)
if [ -n "$PROJECT" ]; then
  cursor "$PROJECT"
fi
