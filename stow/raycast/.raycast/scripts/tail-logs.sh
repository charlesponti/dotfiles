#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Tail Logs
# @raycast.mode silent
# @raycast.packageName Docker

CONTAINER=$(docker ps --format "{{.Names}}" | fzf)
if [ -n "$CONTAINER" ]; then
  ghostty -e "docker logs -f $CONTAINER"
fi
