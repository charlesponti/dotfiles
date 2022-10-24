#!/usr/bin/env bash

source ~/.dotfiles/bin/printf.sh

informer "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew update

brew tap 'homebrew/bundle'

## Install tools
brew install coreutils
brew install jq               # JSON parser
brew install kubectl          # Kubernetes
brew install minikube         # Minikube
brew install starship         # Prompt
brew install trash            # Trash (rm -rf replacement)
brew install tree             # Tree (display directories as tree)
brew install unrar            #
brew install volta            # NodeJS version management
brew install wget             #

## Install commonly used applications

# terminal
brew install --cask fig

# Notes
brew install --cask obsidian

# web browsing
brew install --cask google-chrome

# spotify
brew install --cask spotify

# diagram editor
brew install --cask drawio

# application managment
brew install --cask setapp

# api testing
brew install --cask postman

# Java
brew tap AdoptOpenJDK/openjdk
brew install --cask adoptopenjdk15

brew doctor
