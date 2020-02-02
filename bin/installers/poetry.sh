install-poetry () {
    pip install -U poetry
    mkdir $ZSH/plugins/poetry
    poetry completions zsh > $ZSH/plugins/poetry/_poetry
}

install-poetry()