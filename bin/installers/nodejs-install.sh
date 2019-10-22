#!/usr/bin/env bash

source ~/.dotfiles/bin/printf.sh

informer "Installing NVM..."
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

informer "Loading NVM..."
. "$HOME/.nvm/nvm.sh"

informer "Installing stable..."
nvm install stable

informer "Installing long-term service verison..."
nvm install lts/boron

informer "Setting default to stable..."
nvm alias default stable

informer "Install NPM completion for ZSH"
git clone https://github.com/lukechilds/zsh-better-npm-completion ~/.oh-my-zsh/custom/plugins/zsh-better-npm-completion
