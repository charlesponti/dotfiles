#!/usr/bin/env bash

source ~/.dotfiles/bin/printf.sh

informer "🍺 Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

brew update

brew tap 'homebrew/bundle'

## Install tools
brew install coreutils        # GNU core utilities
brew install jq               # JSON parser
brew install kubectl          # Kubernetes
brew install ffmpeg@4         # Video converter
brew install lsd              # `ls` replacement
brew install minikube         # Minikube
brew install starship         # Prompt
brew install trash            # Trash (rm -rf replacement)
brew install tree             # Tree (display directories as tree)
brew install unrar            # Unarchiving tool
brew install wget             # Download tool

## Install applications
brew install --cask fig                  # Terminal
brew install --cask obsidian             # Note taking
brew install --cask google-chrome        # Browser
brew install --cask spotify              # Music
brew install --cask drawio               # Diagrams
brew install --cask setapp               # App store
brew install --cask postman              # API testing
brew tap AdoptOpenJDK/openjdk            # Java
brew install --cask adoptopenjdk15       # Java

brew doctor
