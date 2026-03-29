# zsh primary shell configuration

# directory where stowed zsh config files live
DOTFILES_SYSTEM_PATH="$HOME/.dotfiles/stow/zsh/system"
for module in env.zsh settings.zsh aliases.zsh; do
  if [[ -f "$DOTFILES_SYSTEM_PATH/$module" ]]; then
    source "$DOTFILES_SYSTEM_PATH/$module"
  fi
done


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

if (( $+commands[sheldon] )); then
  eval "$(sheldon source)"
fi

export FAST_WORK_DIR="$HOME/.config/fsh"
# fast-theme is idempotent once activated; run it manually when the overlay
# changes rather than on every shell startup (it also prints style errors).

autoload -Uz compinit
# Only rebuild the completion dump when it is older than 20 hours, saving the
# full fpath scan on every interactive shell open.
if [[ -n $HOME/.zcompdump(#qN.mh+20) ]]; then
  compinit -i -d "$HOME/.zcompdump"
else
  compinit -C -i -d "$HOME/.zcompdump"
fi

mkdir -p "$HOME/.cache/zsh"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/.zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{245}%d%f'
zstyle ':completion:*:messages' format '%F{245}%d%f'
zstyle ':completion:*:warnings' format '%F{174}no matches for:%f %d'
zstyle ':completion:*' list-prompt '%F{240}%S%M matches%s%f'
zstyle ':completion:*' select-prompt '%F{240}%Sscroll%s%f'
zstyle ':completion:*' rehash true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' special-dirs true
zstyle ':fzf-tab:*' fzf-flags --height=40 --layout=reverse --border
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'command eza -la --color=always $realpath 2>/dev/null || command ls -la $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -f $realpath ]] && (command bat --style=numbers --color=always --line-range=:200 $realpath 2>/dev/null || command sed -n "1,200p" $realpath)'

bindkey -e
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[f' forward-word
bindkey '^[b' backward-word
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

export STARSHIP_CONFIG="$HOME/.config/starship.toml"

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
else
  PROMPT='%F{cyan}%1~%f %F{green}>%f '
fi

# Load local customizations
[[ -f "$HOME/.localrc" ]] && source "$HOME/.localrc"

# Add Maestro to PATH
export PATH=$PATH:$HOME/.maestro/bin

# bun completions
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
