#!/usr/bin/env bash
# Simplified installation script for dotfiles
# Usage: ./install.sh [--bootstrap]

set -euo pipefail

# Parse arguments
BOOTSTRAP_MODE=false
if [[ "${1:-}" == "--bootstrap" ]]; then
    BOOTSTRAP_MODE=true
fi

# Load library
source "$HOME/.dotfiles/bin/lib.sh"

DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_REPO="https://github.com/charlesponti/dotfiles.git"

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Bootstrap mode: clone and install
if [[ "$BOOTSTRAP_MODE" == true ]]; then
    log "🚀 Bootstrap mode: cloning dotfiles repository..."
    
    # Check if running on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        fail "This script is designed for macOS only."
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
    
    cd "$DOTFILES_DIR"
fi

# Core installation
informer "🚀 Starting dotfiles installation..."

# Check OS
if [[ "$OSTYPE" != "darwin"* ]]; then
    fail "This script is designed for macOS only."
fi

# 1. Install Homebrew & Packages
informer "🍺 Installing Homebrew and packages..."
if ! command -v brew >/dev/null 2>&1; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    log "Installing packages from Brewfile..."
    brew bundle install --file "$DOTFILES/Brewfile"
else
    success "Homebrew is already installed."
    log "Installing/updating packages from Brewfile..."
    brew bundle install --file "$DOTFILES/Brewfile"
fi

# 2. Setup Git Configuration
informer "👤 Setting up Git..."
if [[ ! -f "$DOTFILES_DIR/stow/git/.gitconfig.local" ]]; then
    log "Configuring Git user information..."
    
    git_credential='cache'
    if [[ "$(uname -s)" == "Darwin" ]]; then
        git_credential='osxkeychain'
    fi
    
    echo -n "Git author name: "
    read -r git_authorname
    echo -n "Git author email: "
    read -r git_authoremail
    
    # Create .gitconfig.local
    cat > "$DOTFILES_DIR/stow/git/.gitconfig.local" << EOF
[user]
    name = $git_authorname
    email = $git_authoremail

[credential]
    helper = $git_credential
EOF
    
    success "Git configuration created."
else
    success "Git configuration already exists."
fi

# 3. Create Symlinks using GNU Stow
informer "🔗 Creating symlinks with GNU Stow..."
cd "$DOTFILES_DIR"
stow -v -t ~ -d stow zsh git tmux starship vim vscode zed bin

# 4. Create essential directories
informer "📁 Creating essential directories..."
mkdir -p "$HOME/Developer"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share"

# Ensure antibody (plugin manager) is installed
if ! command -v antibody >/dev/null 2>&1; then
    log "Installing antibody plugin manager..."
    if command -v brew >/dev/null 2>&1; then
        brew install getantibody/tap/antibody >/dev/null 2>&1 || brew install antibody >/dev/null 2>&1 || true
    fi

    # Fallback to direct binary download if antibody is still unavailable.
    if ! command -v antibody >/dev/null 2>&1; then
        mkdir -p "$HOME/.local/bin"
        TMP_ARCHIVE="/tmp/antibody.tar.gz"
        TMP_DIR="/tmp/antibody-extract"
        ARCH="$(uname -m)"
        if [[ "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then
            curl -fsSL "https://github.com/getantibody/antibody/releases/latest/download/antibody_Darwin_arm64.tar.gz" -o "$TMP_ARCHIVE" \
              || curl -fsSL "https://github.com/getantibody/antibody/releases/latest/download/antibody_Darwin_x86_64.tar.gz" -o "$TMP_ARCHIVE" \
              || true
        else
            curl -fsSL "https://github.com/getantibody/antibody/releases/latest/download/antibody_Darwin_x86_64.tar.gz" -o "$TMP_ARCHIVE" || true
        fi
        if [[ -f "$TMP_ARCHIVE" ]]; then
            rm -rf "$TMP_DIR"
            mkdir -p "$TMP_DIR"
            if tar -xzf "$TMP_ARCHIVE" -C "$TMP_DIR" >/dev/null 2>&1 && [[ -f "$TMP_DIR/antibody" ]]; then
                cp "$TMP_DIR/antibody" "$HOME/.local/bin/antibody"
                chmod +x "$HOME/.local/bin/antibody"
            fi
        fi
    fi
fi

# Build antibody bundle from plugin list (if available)
ANTIBODY_BUNDLE="$HOME/.local/share/antibody/bundle.zsh"
mkdir -p "$(dirname "$ANTIBODY_BUNDLE")"
if command -v antibody >/dev/null 2>&1 && [[ -f "$DOTFILES_DIR/stow/zsh/antibody-plugins.txt" ]]; then
    antibody bundle < "$DOTFILES_DIR/stow/zsh/antibody-plugins.txt" > "$ANTIBODY_BUNDLE" || true
fi

# 5. Final Setup
informer "🎯 Final setup..."

# Set shell to zsh
if [[ "$SHELL" != */zsh ]]; then
    log "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
    success "Default shell changed to zsh."
fi

success "🚀 Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Run health check: ./bin/status.sh health"
echo "  3. Show commands: make help"

if [[ "$BOOTSTRAP_MODE" == true ]]; then
    echo ""
    success "🎉 Bootstrap complete! Your development environment is ready."
fi
