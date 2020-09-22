# MANPATH
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# SQLite
export SQLITE_PATH="/usr/local/opt/sqlite/bin"

# Clears every item in your path
unset path

# List all path entries you want before the "standard" PATH
PATH="\
/usr/local/opt/python@3.7/bin:\
/usr/bin:/usr/sbin:\
/usr/local/bin:/usr/local/sbin:\
/bin:/sbin:\
/usr/local/opt/openssl/bin:\
/usr/local/opt/curl/bin:\
/usr/local/opt/texinfo/bin:\
/usr/local/opt/sqlite/bin:\
/usr/libexec:\
/Library/Apple/usr/bin"


# Clean up possible duplicates in your path (ex. if iTerm is launching shells as login shells)
# Make PATH Entries Great Again: (Unique)
typeset -aU path

# Finally, export the whole enchilada
export PATH

# Also make sure macOS gets the man pages right:
export MANPATH=$(manpath)
