#!/usr/bin/env bash

# Install Pyenv for managing Python versions
brew install pyenv

# Install Python
~/.pyenv/bin/pyenv install 3.7.4

# Set global version
~/.pyenv/bin/pyenv global 3.7.4

# Install Pygments for `pcat` alias
~/.pyenv/shims/pip3 install pygments

exec $SHELL
