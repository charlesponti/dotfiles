#!/usr/bin/env bash

source ~/.dotfiles/bin/printf.sh

informer "⬇️ Installing NodeJS version magager..."
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash

informer "⬇️ Installing stable..."
nvm install lts/hydrogen
