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

# `tmux` without arguments creates a new session by default.  most of the
# time I just want to re‑attach to whatever was already running, and the
# behaviour you described (new window, not the old session) happens when a
# server is already running but no session is specified.  make the command
# smarter:
#
#   * if we're already inside tmux, forward the arguments so nested runs
#     still work the way tmux expects.
#   * otherwise try to attach first and fall back to creating a new session
#     (or let tmux handle the args directly if you pass a name).
#
# the `attach || new` pattern is what the documentation mentions in the
# README and guide, and mirrors tmux's `-A`/`-a` behaviour roughly.
# this fixes the “opens a new window instead of previous session” problem.
#
# see: https://man.tmux.org/ and the TMUX_GUIDE.md in this repo
# for more background on tmux session management.

_tmux_auto() {
  # if the TMUX variable is set we are already in a session; just proxy
  # the command so that nested invocations still create windows/panes as
  # expected.
  if [[ -n "$TMUX" ]]; then
    command tmux "$@"
  else
    # try to re‑attach; if that fails (no sessions) create a new one using
    # whatever arguments were supplied.
    command tmux attach "$@" 2>/dev/null || command tmux new-session "$@"
  fi
}
alias tmux='_tmux_auto'
