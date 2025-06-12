#!/usr/bin/env bash

# Dotfiles installation script
# Usage: ./install.sh

set -euo pipefail

dotfiles="$HOME/.dotfiles"
source "$dotfiles/bin/printf.sh"

# Initialize options
overwrite_all=false
backup_all=false
skip_all=false

# Function to check if running on macOS
check_os() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        error "This setup script is designed for macOS only."
        exit 1
    fi
}

link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

SCRIPTS="$dotfiles/bin"

# Check operating system
check_os

informer "🚀 Starting dotfiles installation..."

# Check for required directories
if [[ ! -d "$dotfiles" ]]; then
    error "Dotfiles directory not found at $dotfiles"
    exit 1
fi

informer "📦 Installing Homebrew"
if ! command -v brew >/dev/null 2>&1; then
    bash "$SCRIPTS/installers/homebrew-install.sh"
    success "Homebrew installed!"
else
    success "Homebrew already installed!"
fi

informer "😲 Installing Git"
bash $SCRIPTS/installers/git-install.sh
success "Done!"

informer "😲 Installing Python"
bash $SCRIPTS/installers/python-install.sh
success "Done!"

informer "😲 Installing NodeJS"
bash $SCRIPTS/installers/nodejs-install.sh
success "Done!"

informer "🍎 Configuring macOS"
echo "Would you like to apply macOS system configurations? This includes:"
echo "  • Finder, Dock, and Trackpad settings"
echo "  • Performance optimizations"
echo "  • Developer-friendly defaults"
echo ""
read -p "Apply macOS configurations? [y/N]: " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    bash "$SCRIPTS/macos.sh" --all
    success "macOS configuration applied!"
else
    echo "Skipped macOS configuration (you can run 'macos-config' later)"
fi

informer "📁 Creating ~/Developer folder"
mkdir -p ~/Developer

informer "🔗 Installing dotfiles symlinks"
bash "$SCRIPTS/symlinks.sh"
success "Symlinks created!"

success "🚀 Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal: source ~/.zshrc"
echo "  2. Run health check: ~/.dotfiles/bin/doctor.sh"
echo "  3. Install apps: brew bundle --file ~/.dotfiles/Brewfile"
