#!/usr/bin/env bash

source ~/.dotfiles/bin/printf.sh

informer "🍺 Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

informer "📦 Installing packages from Brewfile..."
# Install everything from Brewfile
brew bundle install --file ~/.dotfiles/Brewfile

informer "🔍 Running brew doctor..."
brew doctor
