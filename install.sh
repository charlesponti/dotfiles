#!/usr/bin/env bash

# Dotfiles installation script
# Usage: ./install.sh

set -euo pipefail

# Load library
source "$HOME/.dotfiles/bin/lib.sh"

informer "🚀 Starting dotfiles installation..."

# Check OS
if [[ "$OSTYPE" != "darwin"* ]]; then
    fail "This script is designed for macOS only."
fi

# 1. Install Homebrew & Packages
informer "🍺 Installing Homebrew and packages..."
if ! command -v brew >/dev/null 2>&1; then
    bash "$DOTFILES/bin/installers/homebrew-install.sh"
else
    success "Homebrew is already installed."
    # still run bundle install just in case
    brew bundle install --file "$DOTFILES/Brewfile"
fi

# 2. Setup Git
informer "👤 Setting up Git..."
bash "$DOTFILES/bin/installers/git-install.sh"

# 3. Create Symlinks
informer "🔗 Creating symlinks..."
bash "$DOTFILES/bin/symlinks.sh"

# 4. macOS Defaults
read -p "Apply macOS system configurations? [y/N]: " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    informer "🍎 Applying macOS configurations..."
    bash "$DOTFILES/bin/macos.sh" --all
    success "macOS configuration applied!"
fi

# 5. Final Setup
informer "📁 Creating ~/Developer folder..."
mkdir -p "$HOME/Developer"

success "🚀 Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Run health check: make doctor"
echo "  3. Use 'make help' to see management commands"
