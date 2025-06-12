#!/usr/bin/env bash
# Core system utilities and helper functions

#=======================================================================
# FILE & DIRECTORY OPERATIONS
#=======================================================================

# File renaming utility
renamer() {
  if [ $# -ne 2 ]; then
    echo "Usage: renamer <pattern> <extension>"
    return 1
  fi
  rename -f "$1" --remove-extension --append="$2"
}

# Create symlink with verbose output
symlink() {
  if [ $# -ne 2 ]; then
    echo "Usage: symlink <source> <target>"
    return 1
  fi
  ln -sfv "$1" "$2"
}

# Quick backup of a file or directory
qbackup() {
  if [ -z "$1" ]; then
    echo "Usage: qbackup <file_or_directory>"
    return 1
  fi
  local backup_name="$1.backup.$(date +%Y%m%d_%H%M%S)"
  cp -r "$1" "$backup_name"
  echo "Backup created: $backup_name"
}

# Find large files
findlarge() {
  local size=${1:-100M}
  find . -type f -size +"$size" -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'
}

# Find duplicate files (macOS compatible)
finddup() {
  find "${1:-.}" -type f -exec md5 {} \; 2>/dev/null | sort | uniq -w32 -dD
}

# Quick disk usage for current directory
usage() {
  du -sh * 2>/dev/null | sort -hr
}

#=======================================================================
# NETWORK & SYSTEM MONITORING
#=======================================================================

# Show processes listening on a specific port
whos_listening() {
  if [ -z "$1" ]; then
    echo "Usage: whos_listening <port>"
    return 1
  fi
  lsof -nP -iTCP:"$1"
}

# Kill process by name
killp() {
  if [ -z "$1" ]; then
    echo "Usage: killp <process_name>"
    return 1
  fi
  pkill -f "$1"
}

# Quick system information
sysinfo() {
  echo "🖥️  System Information"
  echo "===================="
  echo "OS: $(uname -s)"
  echo "Kernel: $(uname -r)"
  echo "Architecture: $(uname -m)"
  echo "Hostname: $(hostname)"
  echo "Uptime: $(uptime | awk '{print $3,$4}' | sed 's/,//')"
  echo "Shell: $SHELL"
  echo "Terminal: $TERM_PROGRAM"
  if command -v sysctl >/dev/null 2>&1; then
    echo "CPU: $(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "Unknown")"
  fi
  if command -v system_profiler >/dev/null 2>&1; then
    echo "Memory: $(system_profiler SPHardwareDataType 2>/dev/null | grep "Memory:" || echo "Unknown")"
  fi
}

# Quick HTTP status check
httpstatus() {
  if [ -z "$1" ]; then
    echo "Usage: httpstatus <url>"
    return 1
  fi
  curl -s -o /dev/null -w "%{http_code}" "$1"
  echo
}

#=======================================================================
# GIT UTILITIES
#=======================================================================

# Delete all local Git branches matching a pattern
delete-all-branches() {
  if [ -z "$1" ]; then
    echo "Usage: delete-all-branches <pattern>"
    return 1
  fi
  git branch | grep "$1" | xargs git branch -D
}

#=======================================================================
# SSH & SECURITY
#=======================================================================

# Create modern SSH key for GitHub (using ed25519)
github-ssh() {
  local email=${1:-""}
  if [ -z "$email" ]; then
    read -p "Enter your GitHub email: " email
  fi
  
  echo "Creating ed25519 SSH key..."
  ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519
  
  echo "Starting SSH agent..."
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519
  
  # Copy public key to clipboard
  pbcopy < ~/.ssh/id_ed25519.pub
  echo "✓ SSH public key copied to clipboard"
  
  # Open GitHub SSH settings
  open https://github.com/settings/ssh
  echo "✓ GitHub SSH settings opened in browser"
}

# Generate random password
genpass() {
  local length=${1:-16}
  openssl rand -base64 32 | head -c "$length" && echo
}

#=======================================================================
# HISTORY & SEARCH
#=======================================================================

# Search zsh history
search-history() {
  if [ -z "$1" ]; then
    echo "Usage: search-history <pattern>"
    return 1
  fi
  grep "$1" "$HOME/.zsh_history"
}

#=======================================================================
# TEXT & DATA PROCESSING
#=======================================================================

# URL encode/decode
urlencode() {
  python3 -c "import urllib.parse; print(urllib.parse.quote('$1'))"
}

urldecode() {
  python3 -c "import urllib.parse; print(urllib.parse.unquote('$1'))"
}

# JSON pretty print from clipboard
jsonpp() {
  pbpaste | python3 -m json.tool | pbcopy
  echo "JSON formatted and copied to clipboard"
}

# Convert markdown to HTML
md2html() {
  if [ -z "$1" ]; then
    echo "Usage: md2html <markdown_file>"
    return 1
  fi
  if command -v pandoc >/dev/null 2>&1; then
    pandoc "$1" -o "${1%.*}.html"
    echo "Converted $1 to ${1%.*}.html"
  else
    echo "pandoc not found. Install with: brew install pandoc"
  fi
}

# Generate QR code for text
qr() {
  if [ -z "$1" ]; then
    echo "Usage: qr <text>"
    return 1
  fi
  if command -v qrencode >/dev/null 2>&1; then
    qrencode -t UTF8 "$1"
  else
    echo "qrencode not found. Install with: brew install qrencode"
  fi
}

#=======================================================================
# WEB UTILITIES
#=======================================================================

# Quick web search from terminal
google() {
  local query=$(python3 -c "import urllib.parse; print(urllib.parse.quote(' '.join(['$@'])))")
  open "https://www.google.com/search?q=${query}"
}