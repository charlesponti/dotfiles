#!/usr/bin/env bash

nvm-update-to-latest() {
    args=$@
    nvm install stable
    nvm alias default stable
}

npm-update-all() {
  npx npm-check-updates -ua
}
