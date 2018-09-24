# MANPATH
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# PHP
# export PHP_PATH="$(brew --prefix homebrew/php/php@7.0)/bin"

# Python
export PYTHON_PATH="/usr/local/opt/python/libexec/bin"

# Go
export GOPATH=~/.go

# SQLite
export SQLITE_PATH="/usr/local/opt/sqlite/bin"

# HomeBrew
export HOMEBREW_PATH="/usr/local/sbin:/usr/local/bin"

# Yarn
export YARN_PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin"

export PATH="$HOMEBREW_PATH:$SQLITE_PATH:$PHP_PATH:$PYTHON_PATH:$GOPATH/bin:${YARN_PATH}:$PATH"
