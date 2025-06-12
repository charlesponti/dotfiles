#!/usr/bin/env bash

# Update script for existing dotfiles installations
# Usage: ~/.dotfiles/update.sh

set -e

DOTFILES_DIR="$HOME/.dotfiles"

# Source printf functions
source "$DOTFILES_DIR/bin/printf.sh"

informer "🔄 Updating dotfiles..."

# Check if we're in a git repository
if ! git -C "$DOTFILES_DIR" rev-parse --git-dir > /dev/null 2>&1; then
    error "Not a git repository. Please reinstall using bootstrap.sh"
    exit 1
fi

# Stash any local changes
if ! git -C "$DOTFILES_DIR" diff-index --quiet HEAD --; then
    informer "📦 Stashing local changes..."
    git -C "$DOTFILES_DIR" stash push -m "Auto-stash before update $(date)"
fi

# Pull latest changes
informer "⬇️  Pulling latest changes..."
git -C "$DOTFILES_DIR" pull origin main

# Update symlinks (in case new files were added)
informer "🔗 Updating symlinks..."
bash "$DOTFILES_DIR/bin/symlinks.sh"

# Update Homebrew packages
if command -v brew >/dev/null 2>&1; then
    informer "🍺 Updating Homebrew packages..."
    brew update && brew upgrade
    brew cleanup
fi

# Update Zinit plugins
if [[ -d "$HOME/.local/share/zinit" ]]; then
    informer "⚡ Updating Zinit plugins..."
    zsh -c "source ~/.zshrc && zinit update --all"
fi

# Update npm global packages
if command -v npm >/dev/null 2>&1; then
    informer "📦 Updating npm global packages..."
    npm update -g
fi

success "✅ Dotfiles updated successfully!"
informer "🔄 Please restart your terminal or run 'source ~/.zshrc'"
