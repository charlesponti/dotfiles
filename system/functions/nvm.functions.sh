#!/usr/bin/env bash

function nvm-update-to-latest() {
    args=$@
    nvm install stable
    nvm alias default stable
}

function npm-update-all() {
  npx npm-check-updates -ua
}
