#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Audio Download
# @raycast.mode fullOutput
# @raycast.packageName Audio Tools
# @raycast.icon 🎵
# @raycast.argument1 { "type": "text", "placeholder": "url" }

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <url> [output_name]"
    exit 1
fi

URL="$1"
OUTPUT_DIR="$HOME/Downloads"

yt-dlp -x --audio-format mp3 -o "$OUTPUT_DIR/%(title)s.%(ext)s" "$URL"