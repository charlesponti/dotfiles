#!/usr/bin/env bash

brew install python

curl -sL https://raw.githubusercontent.com/brainsik/virtualenv-burrito/master/virtualenv-burrito.sh | $SHELL

echo "\n#Virtualenv\nsource /$HOME/.venvburrito/startup.sh" >> ~/.bash_profile.local
