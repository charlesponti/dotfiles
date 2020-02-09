#!/usr/bin/env bash

# Install RVM
\curl -sSL https://get.rvm.io | bash -s stable

# Add to end of zshrc
echo "source $HOME/.rvm/bin" >> $dotfiles/home/.zshrc

# Restart shell
reload!

# Install Ruby
rvm install 2.2.0
