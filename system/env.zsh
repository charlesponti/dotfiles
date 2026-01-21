# ======================================================================
# PATH CONFIGURATION
# ======================================================================

# Using Zsh associative array for clean path management
path=(
    "$HOME/.dotfiles/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/usr/local/bin"
    "/usr/local/sbin"
    "/usr/local/opt/python@3.12/libexec/bin"
    "/usr/local/opt/postgresql@15/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
    "$HOME/.bun/bin"
    "$HOME/.codeium/windsurf/bin"
    "$HOME/.sst/bin"
    "$HOME/.cache/lm-studio/bin"
    "$HOME/.antigravity/antigravity/bin"
    "/usr/bin"
    "/usr/sbin"
    "/bin"
    "/sbin"
    "$path[@]"
)

# Export unique PATH
export PATH

# Man pages
export MANPATH="/opt/homebrew/share/man:/usr/local/share/man:/usr/share/man:$MANPATH"

# ======================================================================
# TOOL CONFIGURATIONS
# ======================================================================

# Editor
export EDITOR="code"
export VISUAL="code"

# Java
export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home"

# Node/Bun/JS/Hominem
export PNPM_HOME="$HOME/Library/pnpm"
export BUN_INSTALL="$HOME/.bun"
export HOMINEM_DB_PATH="$HOME/.hominem/db.sqlite"

# Python
export CLOUDSDK_PYTHON="/opt/homebrew/bin/python3"

# Colors
export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

# Localization
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
