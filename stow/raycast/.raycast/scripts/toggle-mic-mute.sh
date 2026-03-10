#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Toggle Mic Mute
# @raycast.mode silent
# @raycast.packageName Audio
# @raycast.icon 🎙️

CURRENT=$(osascript -e 'input volume of (get volume settings)')

if [ "$CURRENT" -eq "0" ]; then
  osascript -e "set volume input volume 75"
else
  osascript -e "set volume input volume 0"
fi
