#!/usr/bin/env bash


# Install Pyenv for managing Python versions
brew install pyenv

# Install Python v3.6.9
~/.pyenv/bin/pyenv install 3.9.5

# Set 3.6.9 as global version to avoid usage of system Python
~/.pyenv/bin/pyenv global 3.9.5

# Install Pygments for `pcat` alias
pip3 install pygments

exec $SHELL