#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Open GitHub Repo
# @raycast.mode silent
# @raycast.packageName Git

URL=$(git config --get remote.origin.url | sed 's/git@github.com:/https:\/\/github.com\//' | sed 's/.git//')

open "$URL"
