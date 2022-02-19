#!/usr/bin/env bash

npm-update () {
  npx npm-check-updates -u
  npm install
}

npm-update-all() {
  npx npm-check-updates -ua
}

nvm-update-to-latest() {
  # Get current version of NPM installed
  current_version=$(nvm version)
  nvm install stable
  nvm alias default stable
  nvm reinstall-packages $current_version
}

ts-init () {
  informer "Installing typescript dependencies"
  npm i typescript tslint ts-node @types/node -D

  informer "Initiating TSLint"
  $(npm bin)/tslint --init

  informer "Initialising Typescript Configuration"
  $(npm bin)/tsc --init
}

jwt() {
  node -e "console.log(require('crypto').randomBytes(256).toString('base64'));"
}