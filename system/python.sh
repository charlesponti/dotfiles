#######################################
#   PYTHON
#######################################

alias py='python'

# Pyenv
if which pyenv >/dev/null; then
  eval "$(pyenv init -)"
fi

# pyenv
export PYENV_VERSION=3.9.19
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

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
  python3 -m venv env

  informer "Activating virtual environment..."
  source env/bin/activate

  informer "Installing Pipenv..."
  pip install --upgrade pip
  pip install -U pipenv

  informer "Installing project dependencies..."
  pipenv install pylint isort black typing pytest

  success "Done!"
}
