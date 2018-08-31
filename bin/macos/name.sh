#!/usr/bin/env bash

# Ask user for new machine name
echo 'Enter new hostname of the machine (e.g. magicSchoolBus)'

# Get value from user input
read hostname

# Tell user that their HostName is being updated
echo "Setting new hostname to $hostname..."
scutil --set HostName "$hostname"
compname=$(sudo scutil --get HostName | tr '-' '.')

# Tell user that ther ComputerName is being updated
echo "Setting computer name to $compname"
scutil --set ComputerName "$compname"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$compname"
