#!/usr/bin/env bash
# JavaScript/Node.js development utilities

#=======================================================================
# NPM UTILITIES
#=======================================================================

# Faster NPM for Europeans (legacy alias)
alias npme='npm --registry http://registry.npmjs.eu'

# Clean node_modules and npm cache
npm_clean() {
  echo "🧹 Cleaning node_modules..."
  find . -name "node_modules" -type d -prune -exec rm -rf '{}' +

  echo "🧹 Clearing npm cache..."
  npm cache clean --force
  echo "✅ NPM cleanup complete"
}

# Full refresh: remove everything and reinstall
npm_refresh() {
  echo "🔄 Full NPM refresh starting..."
  
  # Remove all node_modules folders
  echo "  → Removing node_modules folders..."
  find . -name "node_modules" -type d -exec rm -rf {} +
  
  # Remove all lock files
  echo "  → Removing lock files..."
  find . -name "package-lock.json" -type f -delete
  find . -name "yarn.lock" -type f -delete
  find . -name "bun.lockb" -type f -delete
  
  # Clear npm cache
  echo "  → Clearing npm cache..."
  npm cache clean --force
  
  # Reinstall dependencies
  echo "  → Reinstalling dependencies..."
  npm install --verbose

  echo "✅ NPM refresh complete"
}

#=======================================================================
# PACKAGE MANAGER SHORTCUTS
#=======================================================================

# NPM shortcuts
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nd='npm run dev'
alias nls='npm list --depth=0'
alias nou='npm outdated'
alias nup='npm update'

# Yarn shortcuts
alias yi='yarn install'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yr='yarn run'
alias ys='yarn start'
alias yt='yarn test'
alias yb='yarn build'
alias yd='yarn dev'

# pnpm shortcuts
alias pni='pnpm install'
alias pna='pnpm add'
alias pnad='pnpm add --save-dev'
alias pnr='pnpm run'
alias pns='pnpm start'
alias pnt='pnpm test'
alias pnb='pnpm build'
alias pnd='pnpm dev'

#=======================================================================
# RUNTIME ENVIRONMENT PATHS
#=======================================================================

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# deno
if [ -f "$HOME/.deno/env" ]; then
  . "$HOME/.deno/env"
fi

# maestro (for Expo and React Native)
export PATH=$PATH:$HOME/.maestro/bin

#=======================================================================
# DEVELOPMENT UTILITIES
#=======================================================================

# Quick project initialization
init_node() {
  local project_name=${1:-"new-project"}
  echo "🚀 Initializing Node.js project: $project_name"
  mkdir -p "$project_name"
  cd "$project_name"
  npm init -y
  echo "✅ Node.js project initialized"
}

# Check for security vulnerabilities
npm_audit() {
  echo "🔍 Running npm security audit..."
  npm audit
  echo "💡 Run 'npm audit fix' to attempt automatic fixes"
}

# Show package information
pkg_info() {
  if [ -z "$1" ]; then
    echo "Usage: pkg_info <package-name>"
    return 1
  fi
  npm view "$1"
}

# Find large packages in node_modules
find_heavy_packages() {
  echo "📦 Finding largest packages in node_modules..."
  if [ -d "node_modules" ]; then
    du -sh node_modules/* | sort -hr | head -20
  else
    echo "❌ No node_modules directory found"
  fi
}

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

# Python shortcuts (JavaScript-related Python tools)
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