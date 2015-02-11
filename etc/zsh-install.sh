#!/usr/bin/env bash

brew install zsh
command -v zsh | sudo tee -a /etc/shells
sudo chsh -s "$(command -v zsh)" "${USER}”
curl -L http://install.ohmyz.sh | sh
