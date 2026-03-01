# zsh helper: make directory and cd into it
# This file is intended to be sourced by ~/.zshrc (or functions.zsh).

# load the shared implementation
# shellcheck source=/dev/null
source "$(dirname "${(%):-%x}")/functions/common/mkcd.sh"
