# ======================================================================
# DIRECTORY FUNCTIONS
# ======================================================================

# Create and enter directory
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# ======================================================================
# FILE UTILITIES
# ======================================================================

# Universal extract
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# ======================================================================
# DEVELOPMENT FUNCTIONS
# ======================================================================

# Git WIP
gwip() {
  git add .
  git commit -m "wip" --no-verify
  git push origin "$(git rev-parse --abbrev-ref HEAD)"
}

# Find large files
findlarge() {
  local size=${1:-100M}
  find . -type f -size +"$size" -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'
}

# ======================================================================
# MACOS UTILITIES
# ======================================================================

# Toggle hidden files in Finder
togglehidden() {
  local current=$(defaults read com.apple.finder AppleShowAllFiles 2>/dev/null)
  if [[ "$current" == "TRUE" ]]; then
    defaults write com.apple.finder AppleShowAllFiles FALSE
    echo "Hidden files HIDDEN"
  else
    defaults write com.apple.finder AppleShowAllFiles TRUE
    echo "Hidden files VISIBLE"
  fi
  killall Finder
}

# Quick system info
sysinfo() {
  echo "🖥️  $(uname -s) $(uname -r) $(uname -m)"
  echo "Uptime: $(uptime | awk '{print $3,$4}' | sed 's/,//')"
  if command -v sysctl >/dev/null 2>&1; then
    sysctl -n machdep.cpu.brand_string
  fi
}
