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

#######################################
#   PYTHON
#######################################

# Install Poetry
install_poetry () {
    curl -SSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
    mkdir $ZSH/plugins/poetry
    poetry completions zsh > $ZSH/plugins/poetry/_poetry
}

# Install dephell
install_dephell() {
    python3 -m pip install --user dephell[full]
    dephell self autocomplete
}
