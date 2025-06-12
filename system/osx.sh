#!/usr/bin/env bash
# macOS-specific utilities and aliases

#=======================================================================
# SYSTEM CONTROL
#=======================================================================

# System maintenance
alias emptytrash="sudo rm -rf ~/.Trash/*"
alias restartmac="sudo shutdown -r now"
alias lock='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

# DNS and network utilities
flushdns() {
  sudo killall -HUP mDNSResponder
  sudo killall mDNSResponderHelper
  sudo dscacheutil -flushcache
  echo "✅ DNS cache flushed"
}

# Network diagnostics
alias netinfo='networksetup -listallhardwareports'
alias wifi='networksetup -setairportpower en0'

#=======================================================================
# FINDER UTILITIES
#=======================================================================

# Show/hide hidden files in Finder
showhidden() {
  defaults write com.apple.finder AppleShowAllFiles TRUE
  killall Finder
  echo "✅ Hidden files are now visible"
}

hidehidden() {
  defaults write com.apple.finder AppleShowAllFiles FALSE
  killall Finder
  echo "✅ Hidden files are now hidden"
}

# Toggle hidden files (more convenient)
togglehidden() {
  local current=$(defaults read com.apple.finder AppleShowAllFiles 2>/dev/null)
  if [[ "$current" == "TRUE" ]]; then
    hidehidden
  else
    showhidden
  fi
}

# Clean up .DS_Store files
cleanup_ds_store() {
  echo "🧹 Cleaning up .DS_Store files..."
  find . -name ".DS_Store" -type f -delete
  echo "✅ .DS_Store files removed"
}

# Rebuild Spotlight index
rebuild_spotlight() {
  echo "🔍 Rebuilding Spotlight index..."
  sudo mdutil -i on /
  sudo mdutil -E /
  echo "✅ Spotlight index rebuild initiated"
}

#=======================================================================
# XCODE & DEVELOPMENT
#=======================================================================

# Open iOS Simulator
alias ios="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"

# Open watchOS Simulator  
alias watchos="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator\ \(Watch\).app"

# Clear Xcode derived data
clear_xcode_cache() {
  echo "🧹 Clearing Xcode derived data..."
  rm -rf ~/Library/Developer/Xcode/DerivedData/*
  echo "✅ Xcode cache cleared"
}

#=======================================================================
# ROSETTA 2 MANAGEMENT (APPLE SILICON)
#=======================================================================

# Ensure Rosetta 2 is available and enabled
ensure_rosetta() {
  if [[ "$(uname -m)" == "arm64" ]]; then
    if ! /usr/bin/pgrep oahd >/dev/null 2>&1; then
      echo "Installing Rosetta 2..."
      sudo softwareupdate --install-rosetta --agree-to-license
      echo "✅ Rosetta 2 installed"
    else
      echo "✅ Rosetta 2 is already running"
    fi
  else
    echo "ℹ️  Running on Intel - Rosetta 2 not needed"
  fi
}

# Switch to ARM64 architecture
switch_to_arm() {
  if [[ "$(uname -m)" == "arm64" ]]; then
    echo "✅ Already running ARM64 natively"
  else
    echo "🔄 Switching to ARM64..."
    arch -arm64 /bin/zsh
  fi
}

#=======================================================================
# SYSTEM CONFIGURATION
#=======================================================================

# Apply comprehensive macOS settings
configure_macos() {
  echo "🍎 Applying macOS system configurations..."
  echo "   This will modify system preferences and may require sudo access."
  read -p "Continue? (y/N): " -n 1 -r
  echo
  
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    "$HOME/.dotfiles/bin/macos.sh" --interactive
  else
    echo "❌ Configuration cancelled."
  fi
}

#=======================================================================
# MACOS CONFIGURATION SHORTCUTS
#=======================================================================

alias macos-config='$HOME/.dotfiles/bin/macos.sh --interactive'
alias macos-all='$HOME/.dotfiles/bin/macos.sh --all'
alias macos-finder='$HOME/.dotfiles/bin/macos.sh finder'
alias macos-dock='$HOME/.dotfiles/bin/macos.sh dock'

# System utilities
alias cpu='top -l 1 | head -n 10 | grep "CPU usage"'
alias memory='top -l 1 | head -n 10 | grep "PhysMem"'
alias battery='pmset -g batt'
alias temp='sudo powermetrics --samplers smc -n 1 -i 1 | grep -i temp'

# Quick access to system preferences
alias prefs='open /System/Applications/System\ Preferences.app'
