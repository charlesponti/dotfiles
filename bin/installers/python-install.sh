#!/usr/bin/env bash

# Install Python
install_python() {
    # Install Pyenv for managing Python versions
    brew install pyenv

    # Install Python v3.6.9
    pyenv install 3.6.9

    # Set 3.6.9 as global version to avoid usage of system Python
    pyenv global 3.6.9
}

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
