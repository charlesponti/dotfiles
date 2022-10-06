# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

# Use Spaceship [https://spaceship-prompt.sh]
source "$HOME/.zsh/spaceship/spaceship.zsh"

# Helpful env variables
SYSTEM_PATH=~/.dotfiles/system

# Enable Kubernetes ZSH completion
source <(kubectl completion zsh)

# Import fancy print function
source $HOME/.dotfiles/bin/printf.sh

# Local computer stuff
source ~/.localrc

# Import personal tings
source $SYSTEM_PATH/aliases.sh
source $SYSTEM_PATH/base.sh
source $SYSTEM_PATH/config.zsh
source $SYSTEM_PATH/docker.sh
source $SYSTEM_PATH/git.sh
source $SYSTEM_PATH/javascript.sh
source $SYSTEM_PATH/osx.sh
source $SYSTEM_PATH/path.sh

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 2>/dev/null
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
$(nvm use node) 2>/dev/null

# Java
export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home"

# GOOGLE CLOUD CLI
export CLOUDSDK_PYTHON="/usr/local/bin/python3.7"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/.google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/.google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/.google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/.google-cloud-sdk/completion.zsh.inc"; fi

# PNPM
export PNPM_HOME="/Users/charlesponti/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
