#!/usr/bin/env bash

# Bootstrap script for fresh installations
# Usage: curl -s https://raw.githubusercontent.com/charlesponti/dotfiles/main/bootstrap.sh | bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_REPO="https://github.com/charlesponti/dotfiles.git"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    error "This script is designed for macOS only."
    exit 1
fi

# Check if Xcode Command Line Tools are installed
if ! xcode-select -p &> /dev/null; then
    log "Installing Xcode Command Line Tools..."
    xcode-select --install
    
    # Wait for installation to complete
    until xcode-select -p &> /dev/null; do
        sleep 5
    done
    
    success "Xcode Command Line Tools installed"
fi

# Clone or update dotfiles repository
if [[ -d "$DOTFILES_DIR" ]]; then
    log "Dotfiles directory exists. Updating..."
    cd "$DOTFILES_DIR"
    git pull origin main
else
    log "Cloning dotfiles repository..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# Run the installation script
log "Running dotfiles installation..."
cd "$DOTFILES_DIR"
bash install.sh

success "🚀 Dotfiles installation complete!"
success "🔄 Please restart your terminal or run 'source ~/.zshrc'"

# Optional: Install additional applications
read -p "Would you like to install recommended applications via Homebrew? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log "Installing recommended applications..."
    bash "$DOTFILES_DIR/bin/installers/apps.sh"
fi
