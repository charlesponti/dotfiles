#!/usr/bin/env bash

BASEDIR=$(dirname "$0")
source $BASEDIR/docker.fn.sh
source $BASEDIR/nvm.functions.sh
source $BASEDIR/osx.functions.sh

renamer () {
  rename -f $1 --remove-extension --append=$2
  # find . -name '*.less' -exec sh -c 'mv "$0" "${0%.less}.css"' {} \; 
}

download_urls () {
  wget -i $1
  cat $1 | xargs -n 1 curl -LO
}

# Download YouTube Audio
youtube-dl-audio () {
  youtube-dl \
    --download-archive downloaded.txt \
    --no-overwrites \
    -ict \
    --yes-playlist \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 \
    --socket-timeout 5 \
    $1
}

# Open current directory in GitKraken
kraken () {
  open -na 'GitKraken' --args -p $(pwd)
}

daily() {
  informer "Upgrading Homebrew packages..."
  brew upgrade

  informer "Cleaning up Homebrew..."
  brew cleanup

  informer "Sending Homebrew to the doctor..."
  brew doctor

  informer "Upgrading NPM modules..."
  npm update -g
}

ts-init () {
  informer "Installing typescript dependencies"
  npm i typescript tslint ts-node @types/node -D

  informer "Initiating TSLint"
  $(npm bin)/tslint --init

  informer "Initialising Typescript Configuration"
  $(npm bin)/tsc --init
}

add-pretter () {
    npm i -D prettier eslint-config-prettier eslint-plugin-prettier
}

ponti-api () {
  # Copy files
  cp $HOME/.dotfiles/templates/ponti-api/** .
  
  # Copy dotfiles
  cp $HOME/.dotfiles/templates/ponti-api/.* .
}

npm-update () {
    npx npm-check-updates -u
    npm install
}

#-------------------------------------------
# command: venv
# description: create new virtualenv
# args:
#   $1 - Name of virtualenv
#-------------------------------------------
ponti-venv () {
  informer "Creating virtual environment..."
  python3 -m venv env

  informer "Activating virtual environment..."
  source env/bin/activate

  informer "Installing pip things..."
  install_pip_packages()

  informer "Installing pipenv things..."
  pipenv install typing pytest

  success "Done!"
}

install_pip_packages() {
  pip install --upgrade pip
  pip install -U pipenv pylint isort black
}

#######################################
# Return list of processes listening on a given port
# Globals:
#   None
# Arguments:
#   $1 - port to search
# Returns:
#   None
#######################################
whos_listening() {
  lsof -nP -iTCP:$1
}
function venv () {
  pyenv -m venv .venv
  . ./.venv/bin/activate
  pip install --upgrade pip
  pip install pipenv pylint isort black
  pipenv install typing pytest
}
