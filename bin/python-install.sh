#!/usr/bin/env bash

brew install pyenv            # version control management
brew install pyenv-virtualenv # virtual environment management

pyenv install 3.6.9

pyenv global 3.6.9

pyenv use 3.6.9

pip install pipenv

curl -sL https://raw.githubusercontent.com/brainsik/virtualenv-burrito/master/virtualenv-burrito.sh | $SHELL

echo "\n#Virtualenv\nsource /$HOME/.venvburrito/startup.sh" >> ~/.bash_profile.local
