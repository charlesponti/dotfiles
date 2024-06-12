#!/usr/bin/env bash

# Ensure that arch arm64 is used for Rosetta 2
ensure_rosetta() {
  if [[ "$(uname -m)" == "arm64" ]]; then
    if [[ -n "$(sysctl -n sysctl.proc_translated)" ]]; then
      echo "Running on ARM64"
    else
      echo "Rosetta is disabled. Enabling..."
      sudo softwareupdate --install-rosetta --agree-to-license
    fi
  else
    echo "Running on Intel"
  fi
}

switch_arch() {
  informer "Switching to ARM64..."
  arch -arm64 /bin/zsh
}

# Flush DNS cache
flushdns() {
  sudo killall -HUP mDNSResponder
  sudo killall mDNSResponderHelper
  sudo dscacheutil -flushcache
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
