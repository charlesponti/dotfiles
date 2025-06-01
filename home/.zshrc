# ======================================================================
# PERFORMANCE OPTIMIZATIONS
# ======================================================================
# Disable compinit security checks for faster startup
ZSH_DISABLE_COMPFIX=true
# Suppress instant prompt warnings for background processes and console output
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# Skip global compinit for faster startup
skip_global_compinit=1

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ======================================================================
# ZINIT SETUP
# ======================================================================
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    # Suppress output during installation to avoid interfering with instant prompt
    {
        print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
        command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
        command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
            print -P "%F{33} %F{34}Installation successful.%f%b" || \
            print -P "%F{160} The clone has failed.%f%b"
    } >/dev/null 2>&1
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh" 2>/dev/null
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# ======================================================================
# CORE SYSTEM PATH AND CONFIGURATION
# ======================================================================
# Source critical configs immediately (including PATH) - suppress any output
SYSTEM_PATH=~/.dotfiles/system
source $SYSTEM_PATH/config.zsh 2>/dev/null
source $SYSTEM_PATH/path.sh 2>/dev/null

# Consolidate PATH exports for efficiency
export PATH="$HOME/.codeium/windsurf/bin:$HOME/.sst/bin:/usr/local/opt/python@3.12/libexec/bin:$HOME/.cache/lm-studio/bin:$HOME/.local/bin:$PATH"

# Java
export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home"

# Load utility functions in background - not needed immediately
{
    source $HOME/.dotfiles/bin/printf.sh
} &!

# ======================================================================
# DEVELOPMENT TOOLS SETUP
# ======================================================================
# NVM Setup - Add Node to PATH immediately but lazy load functions
export NVM_DIR="$HOME/.nvm"
# Add the latest installed node version to PATH immediately
if [ -s "$NVM_DIR/nvm.sh" ]; then
    LATEST_NODE_VERSION=$(ls -1 "$NVM_DIR/versions/node" 2>/dev/null | sort -V | tail -1)
    if [ -n "$LATEST_NODE_VERSION" ] && [ -d "$NVM_DIR/versions/node/$LATEST_NODE_VERSION" ]; then
        export PATH="$NVM_DIR/versions/node/$LATEST_NODE_VERSION/bin:$PATH"
    fi
fi

# Lazy load full NVM functionality when nvm command is used
nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
}

# Bun Setup - Add to PATH immediately but lazy load completions
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Lazy load bun completions for faster startup
bun() {
    if [[ ! -f "$HOME/.bun/_bun_loaded" ]]; then
        [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
        touch "$HOME/.bun/_bun_loaded"
    fi
    command bun "$@"
}

# ======================================================================
# SYSTEM CONFIGURATIONS
# ======================================================================
# Load system configurations - suppress any output during initialization
source $SYSTEM_PATH/aliases.sh 2>/dev/null
source $SYSTEM_PATH/base.sh 2>/dev/null
source $SYSTEM_PATH/docker.sh 2>/dev/null
source $SYSTEM_PATH/git.sh 2>/dev/null
source $SYSTEM_PATH/javascript.sh 2>/dev/null
source $SYSTEM_PATH/python.sh 2>/dev/null
source $SYSTEM_PATH/osx.sh 2>/dev/null
source $SYSTEM_PATH/gcloud.sh 2>/dev/null

# ======================================================================
# PLUGINS AND THEMES
# ======================================================================
# Load Zinit plugins with turbo mode for faster startup
zinit wait lucid for \
    zdharma-continuum/fast-syntax-highlighting \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \
    mafredri/zsh-async \
    rupa/z \
    hlissner/zsh-autopair

# Load Zinit annexes with turbo mode
zinit wait lucid light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Load powerlevel10k theme
zinit ice depth"1"
zinit light romkatv/powerlevel10k

# Load p10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ======================================================================
# TOOL CONFIGURATIONS
# ======================================================================
# Lazy load fzf key bindings - only when needed, suppress output
[ -f ~/.fzf.zsh ] && {
    fzf() {
        source ~/.fzf.zsh 2>/dev/null
        unfunction fzf
        fzf "$@"
    }
}

# ======================================================================
# APPLICATION SPECIFIC SETTINGS
# ======================================================================
# Hominem environment variables
export HOMINEM_DB_PATH="/Users/charlesponti/.hominem/db.sqlite"

# Set default shell for VSCode - suppress any output
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)" 2>/dev/null

# ======================================================================
# LOCAL CONFIGURATION
# ======================================================================
# Load local computer specific configuration if it exists - suppress output
[ -f ~/.localrc ] && source ~/.localrc 2>/dev/null
