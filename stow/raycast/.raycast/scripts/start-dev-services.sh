#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Start Dev Services
# @raycast.mode silent
# @raycast.packageName Dev

brew services start postgresql
brew services start redis
