#!/usr/bin/env bash

echo 'Installing Homebrew...'
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update

brew tap 'homebrew/bundle'
brew tap homebrew/php

brew install coreutils
brew install hub
brew install grc
brew install jq # commandline JSON parser
brew install trash
brew install unrar
brew install wget
brew install tree

brew prune
brew doctor
