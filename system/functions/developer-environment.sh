
developer-environment() {
    if [[ "$1" == "python" ]]; then
        pip install --upgrade pip poetry isort pylint black
    fi
}