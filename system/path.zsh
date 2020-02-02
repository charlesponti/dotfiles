# MANPATH
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# Python
export PYTHON_PATH="/usr/local/opt/python/libexec/bin"
export ARCANIST="$HOME/.arc/arcanist/bin"
export POETRY=$HOME/.poetry/bin

# Go
export GOPATH="$HOME/.go"

# SQLite
export SQLITE_PATH="/usr/local/opt/sqlite/bin"

# HomeBrew
export HOMEBREW_PATH="/usr/local/sbin:/usr/local/bin"

# kafka
export KAFKA="$HOME/.kafka"

# Clears every item in your path
unset path

# List all path entries you want before the "standard" PATH
PATH="\
$HOME/.cargo/bin:\
$HOME/lib/sbcl/bin:\
/usr/local/opt/openssl/bin:\
/usr/local/opt/curl/bin:\
/usr/local/opt/texinfo/bin:\
/usr/local/opt/sqlite/bin:\
/usr/local/bin:\
/usr/bin:\
/bin:\
/usr/sbin:\
/sbin:\
/Library/Apple/usr/bin:\
/Library/Apple/bin:/usr/libexec"

PATH="\
$HOMEBREW_PATH:\
$SQLITE_PATH:\
$PHP_PATH:\
$PYTHON_PATH:\
$GOPATH/bin:\
$ARCANIST:\
$POETRY:\
$KAFKA:\
$PATH"

# Clean up possible duplicates in your path (ex. if iTerm is launching shells as login shells)
# Make PATH Entries Great Again: (Unique)
typeset -aU path
# Finally, export the whole enchilada
export PATH
# Also make sure macOS gets the man pages right:
export MANPATH=$(manpath)
