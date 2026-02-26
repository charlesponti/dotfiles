# zsh primary shell configuration

DOTFILES_SYSTEM_PATH="$HOME/.dotfiles/system"
for module in env.zsh settings.zsh aliases.zsh functions.zsh; do
  if [[ -f "$DOTFILES_SYSTEM_PATH/$module" ]]; then
    source "$DOTFILES_SYSTEM_PATH/$module"
  fi
done

lane-core() {
  if [[ -n "${CORE_PATH_BASE:-}" ]]; then
    export PATH="$CORE_PATH_BASE"
  fi
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

export STARSHIP_CONFIG="$HOME/.config/starship.toml"

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
else
  PROMPT='%F{cyan}%1~%f %F{green}>%f '
fi
