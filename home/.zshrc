# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle lukechilds/zsh-nvm
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle docker
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Tell Antigen that you're done.
antigen apply

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
if [[ -e ~/.localrc ]]; then
  source ~/.localrc
fi

dotfiles=$HOME/.dotfiles
SYSTEM_PATH=$dotfiles/system

# Enable Kubernetes ZSH completion
source <(kubectl completion zsh)

# Import fancy print function
source $dotfiles/bin/printf.sh

# Import aliases, functions, and more
# for f in $SYSTEM_PATH/**; do source $f; done

# Import Path script again to ensure that the path is correct
source $SYSTEM_PATH/aliases.sh
source $SYSTEM_PATH/base.sh
source $SYSTEM_PATH/config.zsh
source $SYSTEM_PATH/docker.sh
source $SYSTEM_PATH/path.sh
source $SYSTEM_PATH/git.sh
source $SYSTEM_PATH/grc.sh
source $SYSTEM_PATH/javascript.sh
source $SYSTEM_PATH/osx.sh
source $SYSTEM_PATH/python.sh

# Add Auto-Suggestions to ZSH
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# NodeJS - NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 2>/dev/null
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
$(nvm use node) 2>/dev/null

# Java
export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home"

# Ruby
eval "$(rbenv init -)"

# Display welcome message
echo "$(python $HOME/.dotfiles/commands/welcome_message.py)"