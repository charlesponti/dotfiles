#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Stop Dev Services
# @raycast.mode silent
# @raycast.packageName Dev

brew services stop postgresql
brew services stop redis
