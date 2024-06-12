#!/usr/bin/env bash

# Install Pyenv for managing Python versions
brew install pyenv

# Install Python
~/.pyenv/bin/pyenv install 3.9.15

# Set global version
~/.pyenv/bin/pyenv global 3.9.15

# Install Pygments for `pcat` alias
~/.pyenv/shims/pip3 install pygments

exec $SHELL
