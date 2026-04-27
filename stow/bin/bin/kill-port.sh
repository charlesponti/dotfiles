#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Kill Port
# @raycast.mode silent
# @raycast.argument1 { "type": "text", "placeholder": "Port" }

lsof -ti :$1 | xargs kill -9
