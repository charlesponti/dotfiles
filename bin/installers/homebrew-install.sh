#!/usr/bin/env bash

set -euo pipefail

source "$HOME/.dotfiles/bin/lib.sh"

informer "🍺 Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

check_cmd brew

informer "📦 Installing packages from Brewfile..."
# Install everything from Brewfile
brew bundle install --file "$DOTFILES/Brewfile"

informer "🔍 Running brew doctor..."
brew doctor
