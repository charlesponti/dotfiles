# ======================================================================
# CORE ALIASES
# ======================================================================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Better ls commands
if command -v eza >/dev/null 2>&1; then
  alias l='eza -la --group-directories-first --git'
  alias ls='eza --group-directories-first'
  alias lt='eza --tree --level=2'
else
  alias l='ls -lAh'
  alias ll='ls -lAh'
  alias ls='ls -GFh'
fi

# General Utilities
alias c="code"
alias cl='clear'
alias v="nvim"
alias grep='grep --color=auto'
alias reload='source ~/.zshrc'
alias copy='pbcopy'
alias paste='pbpaste'
alias json='python3 -m json.tool'
alias rm="trash"

# Modern Replacements
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
fi
if command -v fd >/dev/null 2>&1; then
  alias find='fd'
fi

# ======================================================================
# GIT ALIASES
# ======================================================================
alias g="git"
alias gs='git status -sb'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git push'
alias gpl='git pull --all --prune'
alias gco='git checkout'
alias gsw='git switch'
alias gb='git branch'
alias gd='git diff'
alias gc='git commit'
alias gca='git commit -a'
alias gcam='git commit -am'
alias gamend='git add . && git commit --amend --no-edit'
alias gstash='git stash'
alias gstashp='git stash pop'

# ======================================================================
# DOCKER ALIASES
# ======================================================================
alias d="docker"
alias dc="docker compose"
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dstats='docker stats --no-stream'
alias dc-u="docker compose up"
alias dc-d="docker compose down"

# ======================================================================
# DEVELOPMENT TOOLS
# ======================================================================

# Node/NPM/Yarn/PNPM/Bun
alias ni='npm install'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias yd='yarn dev'
alias pnd='pnpm dev'
alias bi='bun install'
alias bd='bun dev'

# Python
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate || source .venv/bin/activate'

# Other
alias specify-init="uvx --from git+https://github.com/github/spec-kit.git specify init . --ai copilot"
alias ghostwire="bun ~/Developer/ghostwire/dist/index.js"
alias config="zed ~/.config"
alias dotfiles="zed ~/.dotfiles"

# ======================================================================
# MACOS ALIASES
# ======================================================================
alias flushdns='sudo killall -HUP mDNSResponder; sudo killall mDNSResponderHelper; sudo dscacheutil -flushcache'
alias emptytrash="sudo rm -rf ~/.Trash/*"
alias ios="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
alias battery='pmset -g batt'

# ======================================================================
# DOTFILES MANAGEMENT
# ======================================================================
alias dotconfig="code ~/.dotfiles"
alias zshconfig="code ~/.zshrc"
alias dash='$HOME/.dotfiles/bin/dashboard.sh'
alias help='$HOME/.dotfiles/bin/help.sh'
