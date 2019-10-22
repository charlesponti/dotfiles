#!/usr/bin/env bash

source ~/.dotfiles/bin/printf.sh

# Set HostName
informer "Enter new hostname of the machine (e.g. magicSchoolBus)"
read hostname # Get value from user input
informer "📝Setting HostName to '$hostname' ..."
scutil --set HostName "$hostname"
compname=$(sudo scutil --get HostName | tr '-' '.')

# Set ComputerName
informer "📝Setting ComputerName to $compname"
scutil --set ComputerName "$compname"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$compname"
