#!/usr/bin/env bash

# Flush DNS cache
function flushdns() {
  sudo discoveryutil mdnsflushcache
}

# Show hidden files
function showhidden() {
  defaults write com.apple.finder AppleShowAllFiles TRUE
  killall Finder
}

# Hide hidden files
function hidehidden() {
  defaults write com.apple.finder AppleShowAllFiles FALSE
  killall Finder
}
