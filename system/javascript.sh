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
. "$HOME/.deno/env"

# maestro (for Expo and React Native)
export PATH=$PATH:$HOME/.maestro/bin

# Enhanced development aliases and functions
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nd='npm run dev'
alias nw='npm run watch'
alias nl='npm run lint'
alias nf='npm run format'
alias nc='npm cache clean --force'
alias nou='npm outdated'
alias nup='npm update'

# Package manager detection and universal commands
pkg_install() {
  if [ -f "package-lock.json" ]; then
    npm install "$@"
  elif [ -f "yarn.lock" ]; then
    yarn add "$@"
  elif [ -f "pnpm-lock.yaml" ]; then
    pnpm add "$@"
  elif [ -f "bun.lockb" ]; then
    bun add "$@"
  else
    echo "No package manager lock file found"
    return 1
  fi
}

pkg_run() {
  if [ -f "package-lock.json" ]; then
    npm run "$@"
  elif [ -f "yarn.lock" ]; then
    yarn "$@"
  elif [ -f "pnpm-lock.yaml" ]; then
    pnpm run "$@"
  elif [ -f "bun.lockb" ]; then
    bun run "$@"
  else
    echo "No package manager lock file found"
    return 1
  fi
}

# Universal package commands
alias pi='pkg_install'
alias pr='pkg_run'

# Development server shortcuts
alias serve='python3 -m http.server 8000'  # Quick HTTP server
alias serve3='python3 -m http.server 3000'
alias servephp='php -S localhost:8000'     # PHP dev server

# Docker shortcuts
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dstop='docker stop $(docker ps -q)'  # Stop all containers
alias drm='docker rm $(docker ps -aq)'     # Remove all containers
alias drmi='docker rmi $(docker images -q)' # Remove all images

# Docker compose shortcuts
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcb='docker-compose build'
alias dcl='docker-compose logs -f'
alias dcp='docker-compose pull'
alias dcr='docker-compose restart'

# Python shortcuts
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate || source .venv/bin/activate'
alias pipr='pip install -r requirements.txt'
alias pipf='pip freeze > requirements.txt'

# Node version management helpers
node_latest() {
  if command -v nvm >/dev/null 2>&1; then
    nvm install node
    nvm use node
  fi
}

node_lts() {
  if command -v nvm >/dev/null 2>&1; then
    nvm install --lts
    nvm use --lts
  fi
}

# Quick project initialization
init_node() {
  npm init -y
  git init
  echo "node_modules/\n.env\n.DS_Store" > .gitignore
  echo "# $1\n\nA new Node.js project." > README.md
}

init_python() {
  python3 -m venv venv
  source venv/bin/activate
  pip install --upgrade pip
  echo "venv/\n__pycache__/\n*.pyc\n.env\n.DS_Store" > .gitignore
  echo "# $1\n\nA new Python project." > README.md
  touch requirements.txt
}

# Quick dependency checks
outdated() {
  echo "📦 Checking for outdated dependencies..."
  if [ -f "package.json" ]; then
    echo "Node.js dependencies:"
    npm outdated
  fi
  if [ -f "requirements.txt" ]; then
    echo "Python dependencies:"
    pip list --outdated
  fi
  if [ -f "Cargo.toml" ]; then
    echo "Rust dependencies:"
    cargo outdated 2>/dev/null || echo "Install cargo-outdated: cargo install cargo-outdated"
  fi
}