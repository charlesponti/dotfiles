# PATH is built in .zshenv (via system/path.zsh) so it's correct for
# every zsh invocation, not just interactive ones; source it here too
# in case env.zsh is ever loaded on its own.
DOTFILES_SYSTEM_PATH="${DOTFILES_SYSTEM_PATH:-$HOME/.dotfiles/stow/zsh/system}"
[[ -f "$DOTFILES_SYSTEM_PATH/path.zsh" ]] && source "$DOTFILES_SYSTEM_PATH/path.zsh"

export EDITOR="code"
export VISUAL="code"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
