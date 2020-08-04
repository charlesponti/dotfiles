#!/usr/bin/env bash

source ~/.dotfiles/bin/printf.sh

informer "Installing Homebrew..."
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update

brew tap 'homebrew/bundle'

brew install grc              # Generic Colorizer
brew install jq               # JSON parser
brew install trash            # Trash (rm -rf replacement)
brew install unrar            #
brew install wget             #
brew install tree             # Tree (display directories as tree)
brew install kubectl          # Kubernetes
brew install minikube         # Minikube

brew doctor
