# ~/.profile - executed by the command interpreter for login shells
# This file is not read by bash(1) if ~/.bash_profile or ~/.bash_login exists.

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Load dotfiles if they exist
if [ -f "$HOME/.dotfiles/system/path.sh" ]; then
    source "$HOME/.dotfiles/system/path.sh"
fi
