#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title System Health
# @raycast.mode fullOutput
# @raycast.packageName System

top -l 1 | head -n 10
docker stats --no-stream
