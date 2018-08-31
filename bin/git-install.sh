#!/usr/bin/env bash

dotfiles=~/.dotfiles
source $dotfiles/printf.sh

# Install git
brew install git

# Install 'hub' as this will be the Git wrapper
brew install --HEAD hub

info 'setup gitconfig'

git_credential='cache'
if [ "$(uname -s)" == "Darwin" ]
then
  git_credential='osxkeychain'
fi

user ' - What is your github author name?'
read -e git_authorname
user ' - What is your github author email?'
read -e git_authoremail

info "Make .gitconfig.local..."
touch $dotfiles/home/.gitconfig.local

info "Add text to local gitconfig..."
sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" $dotfiles/bin/.gitconfig.local.example > $dotfiles/home/.gitconfig.local

success 'gitconfig'

setup_gitconfig