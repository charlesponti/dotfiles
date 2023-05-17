#!/usr/bin/env bash

source ~/.dotfiles/bin/printf.sh

informer "Installing Volta..."
curl https://get.volta.sh | bash

informer "Installing stable..."
volta install node@16.16.0
