# Sourced by every zsh invocation (login, interactive, or not) --
# unlike .zshrc, which only loads for interactive shells. Sets up
# PATH here so mise-managed tool versions win over Homebrew even in
# non-interactive contexts (GUI apps, editors, scripts, cron) that
# never source .zshrc.
[[ -f "$HOME/.dotfiles/stow/zsh/system/path.zsh" ]] && source "$HOME/.dotfiles/stow/zsh/system/path.zsh"

[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
