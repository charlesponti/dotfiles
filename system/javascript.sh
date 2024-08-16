#!/usr/bin/env bash

# Faster NPM for europeans.
alias npme='npm --registry http://registry.npmjs.eu'

npm_clean() {
  informer "Cleaning node_modules"
  find . -name "node_modules" -type d -prune -exec rm -rf '{}' +;

  informer "Clearing npm cache"
  npm cache clean --force
}

npm_refresh () {
  informer "Reinstalling node_modules"
  npm_clean
  npm install
}


# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fnm
FNM_PATH="$HOME/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  # eval "`fnm env`"
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"