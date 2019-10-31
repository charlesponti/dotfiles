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

dotfiles=$HOME/.dotfiles
SYSTEM_PATH=$dotfiles/system

# Enable Kubernetes ZSH completion
source <(kubectl completion zsh)

# Import Stuffs
source $dotfiles/bin/printf.sh
source $SYSTEM_PATH/grc.zsh
source $SYSTEM_PATH/config.zsh
source $SYSTEM_PATH/aliases/base.sh
source $SYSTEM_PATH/functions/base.sh
source $SYSTEM_PATH/path.zsh
# source $dotfiles/bin/graphql-completion.sh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# The next line updates PATH for the Google Cloud SDK.
# if [ -f "$HOME/.google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/.google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
# if [ -f "$HOME/.google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/.google-cloud-sdk/completion.zsh.inc"; fi

# NodeJS - NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  2>/dev/null
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
$(nvm use node) 2>/dev/null

# Python, PyEnv, PipEnv & Pyenv-Virtualenv
export PIPENV_VERBOSITY=-1
export PYENV_VERSION="3.6.9"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Java
export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk//Contents/Home"

# Apache Airflow
function airflow-init () {
  mkdir ./airflow_home
  cd airflow_home
  airflow initdb
}
export AIRFLOW_HOME="$(pwd)/airflow_home"

# Apache Spark
export PYSPARK_DRIVER_PYTHON="/usr/local/ipython/bin/ipython"

# Hadoop
alias hstart="/usr/local/Cellar/hadoop/3.2.1/sbin/start-all.sh"
alias hstop="/usr/local/Cellar/hadoop/3.2.1/sbin/stop-all.sh"
