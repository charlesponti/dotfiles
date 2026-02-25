# zsh primary shell configuration

# 1) Minimal env and deterministic PATH baseline (core lane)
typeset -ga CORE_PATH_PARTS
CORE_PATH_PARTS=(
  "$HOME/.local/share/mise/shims"
  "$HOME/.dotfiles/bin"
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "/usr/local/bin"
  "/usr/local/sbin"
  "/usr/local/opt/python@3.12/libexec/bin"
  "/usr/local/opt/postgresql@15/bin"
  "$HOME/.cargo/bin"
  "$HOME/go/bin"
  "$HOME/.local/bin"
  "$HOME/.bun/bin"
  "$HOME/.cache/lm-studio/bin"
  "$HOME/.nix-profile/bin"
  "/nix/var/nix/profiles/default/bin"
  "$HOME/bin"
  "/usr/bin"
  "/usr/sbin"
  "/bin"
  "/sbin"
)

export CORE_PATH_BASE="$(IFS=:; echo "${CORE_PATH_PARTS[*]}")"
export PATH="$CORE_PATH_BASE"
export ADVANCED_LANE_ACTIVE=false
export NIX_CONFIG="extra-experimental-features = nix-command flakes"

lane-core() {
  export PATH="$CORE_PATH_BASE"
  export ADVANCED_LANE_ACTIVE=false
  echo "lane-core: active"
}

lane-advanced() {
  local extras=()
  local p
  for p in "$HOME/.ollama/bin" "/opt/homebrew/opt/llvm/bin" "/opt/homebrew/opt/openjdk/bin"; do
    [[ -d "$p" ]] && extras+=("$p")
  done

  if (( ${#extras[@]} > 0 )); then
    export PATH="$(IFS=:; echo "${extras[*]}"):$CORE_PATH_BASE"
  else
    export PATH="$CORE_PATH_BASE"
  fi
  export ADVANCED_LANE_ACTIVE=true
  echo "lane-advanced: active"
}

# 2) Essential shell options
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# 3) Non-critical hooks and prompt (gated for startup speed)
# Default: shims in PATH without expensive startup hooks.
: "${DOTFILES_ENABLE_MISE_HOOK:=0}"
if [[ "$DOTFILES_ENABLE_MISE_HOOK" == "1" ]] && (( $+commands[mise] )); then
  eval "$(mise activate zsh)"
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi

if [[ -f "$HOME/.local/share/antibody/bundle.zsh" ]]; then
  source "$HOME/.local/share/antibody/bundle.zsh"
fi

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
else
  PROMPT='%n@%m %1~ %# '
fi
