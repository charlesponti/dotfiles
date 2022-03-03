#!/usr/bin/env bash

renamer () {
  rename -f $1 --remove-extension --append=$2
}

block-em () {
  sudo cp ~/.dotfiles/bin/block-em/block-em.txt /etc/hosts
  flushdns
}

unblock-em () {
  sudo cp ~/.dotfiles/bin/block-em/original.txt /etc/hosts
  flushdns
}

daily() {
  informer "Upgrading Homebrew packages..."
  brew upgrade

  informer "Cleaning up Homebrew..."
  brew cleanup

  informer "Sending Homebrew to the doctor..."
  brew doctor
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
