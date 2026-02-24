# ======================================================================
# PATH CONFIGURATION
# ======================================================================

# Using Zsh associative array for clean path management

typeset -U path
PATH_CANDIDATES=(
    "$HOME/.local/share/mise/shims"
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
    "$HOME/bin"
    "/usr/bin"
    "/usr/sbin"
    "/bin"
    "/sbin"
)

path=()
for candidate in "${PATH_CANDIDATES[@]}"; do
    [[ -d "$candidate" ]] && path+=("$candidate")
done

if [[ -n "${PATH:-}" ]]; then
    IFS=: read -ra existing_path <<< "$PATH"
    for entry in "${existing_path[@]}"; do
        [[ -n "$entry" && -d "$entry" ]] && path+=("$entry")
    done
fi

# Export unique PATH (includes existing entries if they point to directories)
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

# JavaScript
export PNPM_HOME="$HOME/Library/pnpm"
export BUN_INSTALL="$HOME/.bun"

# Colors
export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

# Localization
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
