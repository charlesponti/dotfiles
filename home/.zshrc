# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

# Load for compdef
autoload -Uz compinit
compinit

# Use [Starship](https://starship.rs)
eval "$(starship init zsh)"

# Use Spaceship [https://spaceship-prompt.sh]
# source "$HOME/.zsh/spaceship/spaceship.zsh"

# Enable Kubernetes ZSH completion
source <(kubectl completion zsh)

# Import fancy print function
source $HOME/.dotfiles/bin/printf.sh

# Local computer stuff
source ~/.localrc

# Import personal tings
SYSTEM_PATH=~/.dotfiles/system
source $SYSTEM_PATH/aliases.sh
source $SYSTEM_PATH/base.sh
source $SYSTEM_PATH/config.zsh
source $SYSTEM_PATH/docker.sh
source $SYSTEM_PATH/git.sh
source $SYSTEM_PATH/javascript.sh
source $SYSTEM_PATH/osx.sh
source $SYSTEM_PATH/path.sh
source $SYSTEM_PATH/python.sh

# Java
export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home"

# GOOGLE CLOUD CLI
export CLOUDSDK_PYTHON="$HOME/.pyenv/versions/3.7.14/bin/python3"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/.google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/.google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/.google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/.google-cloud-sdk/completion.zsh.inc"; fi

# Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# PNPM
export PNPM_HOME="/Users/charlesponti/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
