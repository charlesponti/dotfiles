# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# Import fancy print function
source $HOME/.dotfiles/bin/printf.sh

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
source $SYSTEM_PATH/gcloud.sh

# Puppeteer
# This is needed for puppeteer to work on M1 Macs
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`

# Java
export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home"

# sst
export PATH="$HOME/.sst/bin:$PATH"

# Plugins
zinit load zdharma-continuum/history-search-multi-word
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light mafredri/zsh-async
zinit light rupa/z
zinit light hlissner/zsh-autopair

# Load powerlevel10k theme
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

# Key bindings for fzf
zinit snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh

# Enable fzf key bindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Local computer stuff
source ~/.localrc