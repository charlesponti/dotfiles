alias reload='source ~/.zshrc'

# show each component of $PATH on its own line with numbers for readability
alias path='echo $PATH | tr ":" "\n" | nl -ba'

alias python='python3'
alias pip='pip3'
alias venv='python3 -m venv'
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