alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias cl='clear'
alias reload='source ~/.zshrc'

# show each component of $PATH on its own line with numbers for readability
alias path='echo $PATH | tr ":" "\n" | nl -ba'


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

# frequently used long commands from history
alias pgstart='brew services start postgresql'   # start/stop Postgres quickly
alias pgstop='brew services stop postgresql'
alias pgstatus='brew services list | grep postgresql'

alias make-dev='make dev-up'                      # project bootstrap
alias brun='bun run'                              # shorter bun runner
alias brd='bun run dev'
alias brdb='bun run build:dev'

alias rm='trash' # safer than `rm`

# helper to commit everything with a message
# usage: gcm "fix xyz"
gcm() { git add --all && git commit -m "$*"; }

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