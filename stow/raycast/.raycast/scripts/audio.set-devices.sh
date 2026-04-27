#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Set Audio Devices
# @raycast.mode silent
# @raycast.packageName Audio
# @raycast.icon 🎧

SwitchAudioSource -t input -s "Elgato Wave XLR"
SwitchAudioSource -t output -s "ponti.pods3"