#!/usr/bin/env bash

echo 'Installing Homebrew...'
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update

brew tap 'homebrew/bundle'
brew tap homebrew/php

brew install coreutils
brew install hub
brew install grc              # Generic Colorizer
brew install jq               # JSON parser
brew install trash            # Trash (rm -rf replacement)
brew install unrar
brew install wget
brew install tree             # Tree (display directories as tree)
brew install kubernetes-cli   # Kubernetes

brew prune
brew doctor
