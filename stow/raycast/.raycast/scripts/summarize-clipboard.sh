#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Summarize Clipboard
# @raycast.mode silent
# @raycast.packageName AI

pbpaste | openai api chat.completions.create \
  -m gpt-4.1-mini \
  -g user="summarize this:"
