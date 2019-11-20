#!/usr/bin/env bash

BASEDIR=$(dirname "$0")
source $BASEDIR/docker.fn.sh
source $BASEDIR/git.functions.sh
source $BASEDIR/nvm.functions.sh
source $BASEDIR/osx.functions.sh

function renamer () {
  rename -f $1 --remove-extension --append=$2
}

# Download YouTube Audio
function youtube-dl-audio () {
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
function kraken () {
  open -na 'GitKraken' --args -p $(pwd)
}

function daily() {
  informer "Upgrading Homebrew packages..."
  brew upgrade

  informer "Cleaning up Homebrew..."
  brew cleanup

  informer "Sending Homebrew to the doctor..."
  brew doctor

  informer "Upgrading NPM modules..."
  npm update -g
}

function ts-init () {
  informer "Installing typescript dependencies"
  npm i typescript tslint ts-node @types/node -D

  informer "Initiating TSLint"
  $(npm bin)/tslint --init

  informer "Initialising Typescript Configuration"
  $(npm bin)/tsc --init
}

#-------------------------------------------
# command: venv
# description: create new virtualenv
# args:
#   $1 - Name of virtualenv
#-------------------------------------------
function venv () {
  python -m venv .venv
  . ./.venv/bin/activate
  pip install --upgrade pip
  pip install pipenv pylint isort black
  pipenv install typing pytest
}

#-------------------------------------------
# command: dev
# description: jump to folder in Developer directory
# args:
#   $1 - name of folder
#   $2 - --open to open in VS Code
#-------------------------------------------
function dev() {
  if [$2 == "--open"]; then
    code ~/Developer/$1
  else
    cd ~/Developer/$1
  fi
}

