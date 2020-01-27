#!/usr/bin/env bash

# Flush DNS cache
flushdns() {
  sudo discoveryutil mdnsflushcache
}

# Show hidden files
showhidden() {
  defaults write com.apple.finder AppleShowAllFiles TRUE
  killall Finder
}

# Hide hidden files
hidehidden() {
  defaults write com.apple.finder AppleShowAllFiles FALSE
  killall Finder
}
