# MANPATH
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# Python
export PYTHON_PATH="/usr/local/opt/python/libexec/bin"
export ARCANIST="$HOME/.phabricator/arcanist/bin"
export POETRY=$HOME/.poetry/bin

# Go
export GOPATH="$HOME/.go"

# SQLite
export SQLITE_PATH="/usr/local/opt/sqlite/bin"

# HomeBrew
export HOMEBREW_PATH="/usr/local/sbin:/usr/local/bin"

export PATH="$HOMEBREW_PATH:$SQLITE_PATH:$PHP_PATH:$PYTHON_PATH:$GOPATH/bin:$ARCANIST:$POETRY:$PATH"
