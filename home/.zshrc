# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

ZSH_THEME=robbyrussell

# Plugins (found in ~/.oh-my-zsh/plugins/*)
plugins=(
  git
  docker
)

# Load ZSH
source $ZSH/oh-my-zsh.sh

#--------------------- User configuration -------------------------------------#

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='code'
else
  export EDITOR='code'
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Stash your environment variables in ~/.localrc. This means they'll stay out
# of your main dotfiles repository (which may be public, like this one), but
# you'll have access to them in your scripts.
if [[ -a ~/.localrc ]]
then
  source ~/.localrc
fi

# NMV
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

dotfiles=$HOME/.dotfiles
SYSTEM_PATH=$dotfiles/system

# Enable Kubernetes ZSH completion
source <(kubectl completion zsh)

# Import Stuffs
source $dotfiles/printf.sh
source $SYSTEM_PATH/grc.zsh
source $SYSTEM_PATH/config.zsh
source $SYSTEM_PATH/aliases/base.sh
source $SYSTEM_PATH/functions/base.sh
source $SYSTEM_PATH/path.zsh
# source $dotfiles/bin/graphql-completion.sh

# The next line updates PATH for the Google Cloud SDK.
# if [ -f "$HOME/.google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/.google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
# if [ -f "$HOME/.google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/.google-cloud-sdk/completion.zsh.inc"; fi

  # Set Spaceship ZSH as a prompt
  autoload -U promptinit; promptinit
  prompt spaceship
