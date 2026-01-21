#!/usr/bin/env bash

set -euo pipefail

source "$HOME/.dotfiles/bin/lib.sh"

# Note: git and gh are installed via Brewfile
# This script just configures git

informer "😃 Let's set up your gitconfig!!"

git_credential='cache'
if [[ "$(uname -s)" == "Darwin" ]]; then
  git_credential='osxkeychain'
fi

user ' - What is your github author name?'
read -r git_authorname
user ' - What is your github author email?'
read -r git_authoremail

informer "🏗 Adding .gitconfig.local configuration"
touch $dotfiles/home/.gitconfig.local
sed \
  -e "s/AUTHORNAME/$git_authorname/g" \
  -e "s/AUTHOREMAIL/$git_authoremail/g" \
  -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" \
  $dotfiles/bin/.gitconfig.local.example > $dotfiles/home/.gitconfig.local

success 'gitconfig'