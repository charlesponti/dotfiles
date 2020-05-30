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