#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Explain Code
# @raycast.mode fullOutput
# @raycast.packageName AI

pbpaste | openai api chat.completions.create \
  -m gpt-4.1-mini \
  -g user="Explain this code snippet:"
