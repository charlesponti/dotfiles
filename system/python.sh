#######################################
#   PYTHON
#######################################

alias py='python'

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PIPENV_PYTHON="$PYENV_ROOT/shims/python"

# Add pyenv to PATH
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

# Initialize pyenv
if which pyenv >/dev/null; then
  eval "$(pyenv init -)"
  eval "$(command pyenv init --path)"
fi

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

#-------------------------------------------
# command: venv
# description: create new virtualenv
# args:
#   $1 - Name of virtualenv
#-------------------------------------------
create-python-environment () {
  informer "Creating virtual environment..."
  python -m venv .venv

  informer "Activating virtual environment..."
  source .venv/bin/activate

  informer "Installing Pipenv..."
  pip install --upgrade pip
  pip install -U pipenv

  informer "Installing project dependencies..."
  pipenv install pylint isort black typing pytest

  success "Done!"
}
