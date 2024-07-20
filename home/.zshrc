# Load for compdef
autoload -Uz compinit
compinit

# Use [Starship](https://starship.rs)
eval "$(starship init zsh)"

# Import fancy print function
source $HOME/.dotfiles/bin/printf.sh

# Local computer stuff
source ~/.localrc

# Source helpers
SYSTEM_PATH=~/.dotfiles/system
source $SYSTEM_PATH/path.sh
source $SYSTEM_PATH/aliases.sh
source $SYSTEM_PATH/base.sh
source $SYSTEM_PATH/config.zsh
source $SYSTEM_PATH/docker.sh
source $SYSTEM_PATH/git.sh
source $SYSTEM_PATH/javascript.sh
source $SYSTEM_PATH/osx.sh
source $SYSTEM_PATH/python.sh
# source $SYSTEM_PATH/gcloud.sh

# Puppeteer
# This is needed for puppeteer to work on M1 Macs
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`

# Java
export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home"

# sst
export PATH="$HOME/.sst/bin:$PATH"

