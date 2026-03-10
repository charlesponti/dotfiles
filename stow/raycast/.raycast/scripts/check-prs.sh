#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Check PRs
# @raycast.mode fullOutput
# @raycast.packageName Git

gh pr list --state open --json title,url,headRefName --template '{{range .}}{{tablerow .title .url}}{{end}}'
