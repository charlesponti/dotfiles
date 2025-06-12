#!/usr/bin/env bash
# Core system aliases and shortcuts

# Guard: Only load if basic commands are available
if ! command -v ls &>/dev/null; then
  return 1
fi

#=======================================================================
# CORE APPLICATION SHORTCUTS
#=======================================================================

# Editor shortcuts
alias c="code"
alias v="nvim"
alias vi="nvim" 
alias vim="nvim"

# Quick configuration access
alias zshconfig="code ~/.zshrc"
alias dotfiles="code ~/.dotfiles"

# System shortcuts
alias cl='clear'
alias reload='source ~/.zshrc'

#=======================================================================
# VERSION CONTROL
#=======================================================================

alias g="git"

#=======================================================================
# KUBERNETES & CONTAINER TOOLS
#=======================================================================

alias k="kubectl"

#=======================================================================
# FILE OPERATIONS & NAVIGATION
#=======================================================================

# Enhanced directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# Better ls commands (with eza if available)
if command -v eza >/dev/null 2>&1; then
  alias l='eza -la --group-directories-first --git'
  alias ll='eza -la --group-directories-first --git'
  alias ls='eza --group-directories-first'
  alias lt='eza --tree --level=2'
  alias lta='eza --tree --level=2 -a'
else
  alias l='ls -lAh'
  alias ll='ls -lAh'
  alias ls='ls -GFh'
fi

# Safe file operations
alias cp='cp -iv'      # Interactive, verbose
alias mv='mv -iv'      # Interactive, verbose
alias mkdir='mkdir -pv' # Create parent dirs, verbose

# Better file removal (using trash if available)
if command -v trash >/dev/null 2>&1; then
  alias rm='trash'
else
  alias rm='rm -i'     # Interactive deletion as fallback
fi

#=======================================================================
# SEARCH & FIND
#=======================================================================

# Find shortcuts
alias ff='find . -type f -name'    # Find files
alias fd='find . -type d -name'    # Find directories

# Enhanced grep with color
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

#=======================================================================
# SYSTEM MONITORING
#=======================================================================

# Process management
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias top='htop'

# Memory and disk usage
alias du='du -kh'
alias df='df -kTh'
alias meminfo='free -m -l -t 2>/dev/null || vm_stat'

# Network
alias ping='ping -c 5'
alias ports='netstat -tulanp 2>/dev/null || lsof -i'

#=======================================================================
# UTILITIES
#=======================================================================

# Copy/paste shortcuts
alias copy='pbcopy'
alias paste='pbpaste'

# JSON pretty print
alias json='python3 -m json.tool'

# URL operations
alias urlencode='python3 -c "import urllib.parse; import sys; print(urllib.parse.quote(sys.argv[1]))"'
alias urldecode='python3 -c "import urllib.parse; import sys; print(urllib.parse.unquote(sys.argv[1]))"'

# History analysis
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

#=======================================================================
# DEVELOPMENT WORKFLOW
#=======================================================================

# Quick project navigation and info
alias newproject='$HOME/.dotfiles/bin/newproject.sh'
alias devenv='$HOME/.dotfiles/bin/devenv.sh'
alias setup='$HOME/.dotfiles/bin/devenv.sh --setup'

# System dashboard and status
alias dashboard='$HOME/.dotfiles/bin/dashboard.sh'
alias dash='$HOME/.dotfiles/bin/dashboard.sh'
alias status='$HOME/.dotfiles/bin/dashboard.sh'

# Performance tools
alias help='$HOME/.dotfiles/bin/help.sh'
alias perf='$HOME/.dotfiles/bin/terminal-performance.sh'

#=======================================================================
# ARCHIVE OPERATIONS
#=======================================================================

alias tarls='tar -tvf'      # List tar contents
alias untar='tar -xf'       # Extract tar

#=======================================================================
# SECURITY & SSH
#=======================================================================

# SSH key management (using modern ed25519 by default)
alias pubkey="cat ~/.ssh/id_ed25519.pub 2>/dev/null || cat ~/.ssh/id_rsa.pub | pbcopy && echo '=> Public key copied to clipboard'"
alias ssh-fingerprint="ssh-keygen -lf ~/.ssh/id_ed25519.pub 2>/dev/null || ssh-keygen -lf ~/.ssh/id_rsa.pub"

#=======================================================================
# DATABASE
#=======================================================================

alias pg='postgres -D /usr/local/var/postgres'

#=======================================================================
# PACKAGE MANAGERS
#=======================================================================

# Homebrew shortcuts
alias brews="brew list"
alias casks="brew list --casks"


#=======================================================================
# HELPER FUNCTIONS
#=======================================================================

# Create directory and navigate into it
mkcd() { 
  mkdir -p "$1" && cd "$1"
}

# Universal extract function
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
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Quick backup function
backup() { 
  cp "$1"{,.bak}
}

# Generate JWT secret
jwt() {
  if command -v node >/dev/null 2>&1; then
    node -e "console.log(require('crypto').randomBytes(256).toString('base64'));"
  else
    openssl rand -base64 64
  fi
}

# Quick project info or navigation
proj() {
  if [ -z "$1" ]; then
    echo "Current project info:"
    devenv
  else
    cd "$1" && devenv
  fi
}

# Weather information
weather() {
  local location=${1:-}
  curl -s "wttr.in/${location}"
}
