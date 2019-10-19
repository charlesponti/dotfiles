#!/usr/bin/env bash

# Intall Pyenv for Python version managemnet
brew install pyenv
pyenv install 3.6.9
pyenv global 3.6.9
pyenv use 3.6.9

# Install Poetry
curl -SSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
