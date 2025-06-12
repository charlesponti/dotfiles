# ~/.bashrc - executed by bash(1) for non-login shells

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Load dotfiles configuration
if [ -d "$HOME/.dotfiles" ]; then
    export DOTFILES="$HOME/.dotfiles"
    
    # Load path configuration
    [ -f "$DOTFILES/system/path.sh" ] && source "$DOTFILES/system/path.sh"
    
    # Load aliases
    [ -f "$DOTFILES/system/aliases.sh" ] && source "$DOTFILES/system/aliases.sh"
    
    # Load functions
    [ -f "$DOTFILES/system/base.sh" ] && source "$DOTFILES/system/base.sh"
fi

# Load local configuration
[ -f ~/.localrc ] && source ~/.localrc
