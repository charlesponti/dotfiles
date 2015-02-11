#!/usr/bin/env bash

brew install nvm
echo "# NVM" > ~/.zshrc
echo "export NVM_DIR=~/.nvm" > ~/.zshrc
echo "source $(brew --prefix nvm)/nvm.sh" > ~/.zshrc
source ~/.zshrc
nvm install v0.10.36
nvm install v0.12.0
nvm install iojs-v1.2.0
