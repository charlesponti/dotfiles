#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Semantic Grep
# @raycast.mode fullOutput
# @raycast.packageName Dev
# @raycast.argument1 { "type": "text", "placeholder": "Query" }

grep -r "$1" .
