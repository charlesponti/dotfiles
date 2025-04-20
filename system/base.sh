#!/usr/bin/env bash

renamer () {
  rename -f $1 --remove-extension --append=$2
}

#######################################
# Delete all local Git branches matching some pattern
# Globals:
#   None
# Arguments:
#   $1 - pattern to find
# Returns:
#   None
#######################################
delete-all-branches() {
  git branch | grep $1 | xargs git branch -D
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

# Create SSH key for github
github-ssh () {
  ssh-keygen -t rsa -b 4096 -C “”
  eval “$(ssh-agent -s)”
  ssh-add ~/.ssh/id_rsa
  open https://github.com/settings/ssh
}

# Create symlink
symlink() {
  ln -sfv $1 $2
}

# Search zsh history
search-zsh-history() {
  cat $HOME/.zsh_history | grep $1
}