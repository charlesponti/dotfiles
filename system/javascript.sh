#!/usr/bin/env bash

ts-init () {
  informer "Installing typescript dependencies"
  pnpm i typescript tslint ts-node @types/node -D

  informer "Initiating TSLint"
  pnpm tslint --init

  informer "Initialising Typescript Configuration"
  pnpm tsc --init
}

jwt() {
  node -e "console.log(require('crypto').randomBytes(256).toString('base64'));"
}
