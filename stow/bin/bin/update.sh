#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$SCRIPT_DIR/lib.sh"
DOTFILES_DIR="$(resolve_dotfiles_root "$SCRIPT_DIR")"

informer "🔄 Updating dotfiles..."

# Check if we're in a git repository
if ! git -C "$DOTFILES_DIR" rev-parse --git-dir > /dev/null 2>&1; then
    fail "Not a git repository. Please reinstall using ./stow/bin/bin/install.sh --bootstrap"
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
bash "$DOTFILES_DIR/stow/bin/bin/symlinks.sh"

# Update Homebrew packages
if command -v brew >/dev/null 2>&1; then
    informer "🍺 Updating Homebrew packages..."
    brew update && brew upgrade
    brew cleanup
fi

# Update npm global packages
if command -v npm >/dev/null 2>&1; then
    informer "📦 Updating npm global packages..."
    npm update -g
fi

success "✅ Dotfiles updated successfully!"
informer "🔄 Please restart your terminal or run 'source ~/.zshrc'"
