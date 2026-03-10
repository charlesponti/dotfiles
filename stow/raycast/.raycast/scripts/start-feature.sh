#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Start Feature
# @raycast.mode silent
# @raycast.packageName Git
# @raycast.argument1 { "type": "text", "placeholder": "Jira ID" }

git checkout -b "feature/$1"
open "https://jira.atlassian.net/browse/$1"
