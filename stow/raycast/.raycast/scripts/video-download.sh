#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Video Download
# @raycast.mode fullOutput
# @raycast.packageName Video Tools
# @raycast.icon 🎬
# @raycast.argument1 { "type": "text", "placeholder": "url" }

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <url>"
    exit 1
fi

URL="$1"
OUTPUT_DIR="$HOME/Downloads"

yt-dlp -f "bv*+ba/b" --merge-output-format mp4 -o "$OUTPUT_DIR/%(title)s.%(ext)s" "$URL"