alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias cl='clear'
alias reload='source ~/.zshrc'

alias g='git'
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
alias gstash='git stash'
alias gstashp='git stash pop'

alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dc-u='docker compose up'
alias dc-d='docker compose down'

alias ni='npm install'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'

if command -v eza >/dev/null 2>&1; then
  alias l='eza -la --group-directories-first --git'
  alias ls='eza --group-directories-first'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
fi

if command -v fd >/dev/null 2>&1; then
  alias find='fd'
fi
