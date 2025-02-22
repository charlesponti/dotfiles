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
  
  
  # Remove all node_modules folders
  find . -name "node_modules" -type d -exec rm -rf {} +
  
  # Remove all package-lock.json files
  find . -name "package-lock.json" -type f -delete

  # Remove all yarn.lock files
  find . -name "bun.lockb" -type f -delete
  
  # Clear npm cache
  npm cache clean --force
  
  # Reinstall node_modules
  npm install --verbose

  printf "\r✓ Reinstalling node_modules\n"
}


# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# deno
. "/Users/charlesponti/.deno/env"

# maestro (for Expo and React Native)
export PATH=$PATH:$HOME/.maestro/bin