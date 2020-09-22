#-------------------------------------------
# Python Things
# The Ponti Inc. 2020
#-------------------------------------------

# Python
alias py='python'

# Pyenv
if which pyenv >/dev/null; then
  eval "$(pyenv init -)"
fi

# Pyenv Virtualenv
if which pyenv-virtualenv-init >/dev/null; then
  eval "$(pyenv virtualenv-init -)"
fi

export PYENV_VERSION=3.6.9
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PIPENV_VERBOSITY=-1

# Add Pyenv to PATH
export PATH="$(pyenv root)/shims:$PATH"

#-------------------------------------------
# command: venv
# description: create new virtualenv
# args:
#   $1 - Name of virtualenv
#-------------------------------------------
ponti-venv () {
  informer "Creating virtual environment..."
  python3 -m venv env

  informer "Activating virtual environment..."
  source env/bin/activate

  informer "Installing pip things..."
  pip install --upgrade pip
  pip install -U pipenv pylint isort black

  informer "Installing pipenv things..."
  pipenv install typing pytest

  success "Done!"
}

developer-environment() {
    if [[ "$1" == "python" ]]; then
        pip install --upgrade pip poetry isort pylint black
    fi
}