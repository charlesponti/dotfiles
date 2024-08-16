#!/usr/bin/env bash

# Empty OS X trash
alias emptytrash="sudo rm -rf ~/.Trash/*"

# Restart Mac
alias restartmac="sudo shutdown -r now"

# Lock current session and proceed to the login screen.
alias lock='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

#------------------------------------------------------------------------
# Xcode
#------------------------------------------------------------------------
alias ios="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
alias watchos="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator\ \(Watch\).app"

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
