#!/usr/bin/env bash

npm-update () {
  npx npm-check-updates -u
  npm install
}

nvm-update-to-latest() {
  # Get current version of NPM installed
  current_version=$(nvm version)
  nvm install stable
  nvm alias default stable
  nvm reinstall-packages $current_version
}

npm-update-all() {
  npx npm-check-updates -ua
}

ts-init () {
  informer "Installing typescript dependencies"
  npm i typescript tslint ts-node @types/node -D

  informer "Initiating TSLint"
  $(npm bin)/tslint --init

  informer "Initialising Typescript Configuration"
  $(npm bin)/tsc --init
}

eslint-init () {
  npm i \
    eslint \
    eslint-plugin-import \
    eslint-plugin-node \
    eslint-plugin-promise \
    eslint-plugin-standard \
    eslint-config-standard \
    prettier \
    eslint-config-prettier \
    eslint-plugin-prettier \
    -D
  
  cp "~/.dotfiles/.eslintrc.js" $(pwd)
}