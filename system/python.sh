# Python
alias py='python'

# Pyenv
if which pyenv >/dev/null; then
  eval "$(pyenv init -)"
fi

# Set version of Python to use
export PYENV_VERSION=3.9.5

# Add Pyenv to PATH
export PATH="$(pyenv root)/shims:$PATH"

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
