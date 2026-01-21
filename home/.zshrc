# ======================================================================
# PERFORMANCE OPTIMIZATIONS
# ======================================================================
# Enable profiling (comment out after profiling)
# zmodload zsh/zprof

# Disable compinit security checks for faster startup
ZSH_DISABLE_COMPFIX=true
# Suppress instant prompt warnings for background processes and console output
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Redirect all potential output during initialization to prevent instant prompt issues
exec 3>&1 4>&2 >/dev/null 2>&1
# Skip global compinit for faster startup
skip_global_compinit=1

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Restore stdout and stderr after instant prompt is loaded
exec 1>&3 2>&4 3>&- 4>&-

# (Reverted) compinit tweaks removed — using default compinit behavior
# ======================================================================
# ZINIT SETUP
# ======================================================================
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    # Completely suppress all installation output to avoid interfering with instant prompt
    {
        command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
        command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
    } >/dev/null 2>&1
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh" 2>/dev/null
autoload -Uz _zinit 2>/dev/null
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# ======================================================================
# CORE SYSTEM CONFIGURATION
# ======================================================================
SYSTEM_PATH=~/.dotfiles/system

# Load environment, settings, aliases, and functions
source $SYSTEM_PATH/env.zsh 2>/dev/null
source $SYSTEM_PATH/settings.zsh 2>/dev/null
source $SYSTEM_PATH/aliases.zsh 2>/dev/null
source $SYSTEM_PATH/functions.zsh 2>/dev/null

# Load dotfiles library for shell usage
source $HOME/.dotfiles/bin/lib.sh 2>/dev/null

# ======================================================================
# DEVELOPMENT TOOLS SETUP
# ======================================================================
# Activate mise for Node and other tool version management - lazy loaded
mise_activate() {
    if [[ -z "${MISE_ACTIVATED:-}" ]]; then
        eval "$(mise activate zsh --shims)"
        export MISE_ACTIVATED=1
    fi
}

# Lazy load mise for relevant commands
node() { mise_activate; command node "$@"; }
npm() { mise_activate; command npm "$@"; }
npx() { mise_activate; command npx "$@"; }
yarn() { mise_activate; command yarn "$@"; }
pnpm() { mise_activate; command pnpm "$@"; }
ruby() { mise_activate; command ruby "$@"; }
gem() { mise_activate; command gem "$@"; }
go() { mise_activate; command go "$@"; }
rustc() { mise_activate; command rustc "$@"; }
cargo() { mise_activate; command cargo "$@"; }

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

# Powerlevel10k removed in favor of Starship (Starship is initialized below if installed)
# If you later want to restore Powerlevel10k, uncomment the lines below.
# zinit ice depth"1"
# zinit light romkatv/powerlevel10k
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Optionally enable Starship prompt if installed. Starship is a fast, cross-shell
# prompt written in Rust. Uncomment to prefer Starship over Powerlevel10k.
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# Initialize zoxide (better cd)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

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
# Set default shell for VSCode - suppress any output
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)" 2>/dev/null

# ======================================================================
# LOCAL CONFIGURATION
# ======================================================================
# Load local computer specific configuration if it exists - suppress output
[ -f ~/.localrc ] && source ~/.localrc 2>/dev/null
