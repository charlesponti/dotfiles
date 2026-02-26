#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ANTIBODY_PLUGINS="$ROOT_DIR/home/antibody-plugins.txt"
ANTIBODY_BUNDLE="$HOME/.local/share/antibody/bundle.zsh"

mkdir -p "$(dirname "$ANTIBODY_BUNDLE")"

if command -v antibody >/dev/null 2>&1 && [[ -f "$ANTIBODY_PLUGINS" ]]; then
  echo "🔧 Rebuilding antibody bundle..."
  antibody bundle < "$ANTIBODY_PLUGINS" > "$ANTIBODY_BUNDLE"
  echo "✅ Antibody bundle written to $ANTIBODY_BUNDLE"
else
  echo "⚠️  antibody binary or plugin list missing; skipping bundle rebuild"
fi

if command -v mise >/dev/null 2>&1; then
  DIRENV_LIB_DIR="$HOME/.config/direnv/lib"
  mkdir -p "$DIRENV_LIB_DIR"
  mise direnv > "$DIRENV_LIB_DIR/use_mise.sh"
  echo "✅ Direnv mise integration written to $DIRENV_LIB_DIR/use_mise.sh"
fi

echo "🔁 Regenerating zcompdump..."
ZSH_SITE_FUNCS="$HOME/.local/share/zsh/site-functions"
mkdir -p "$ZSH_SITE_FUNCS"

prune_dangling_symlinks() {
  local dir="$1"
  [[ -d "$dir" ]] || return 0

  find "$dir" -type l -print0 2>/dev/null | while IFS= read -r -d '' link; do
    [[ -e "$link" ]] || rm -f "$link"
  done
}

prune_dangling_symlinks "$ZSH_SITE_FUNCS"
prune_dangling_symlinks "/opt/homebrew/share/zsh/site-functions"
prune_dangling_symlinks "/opt/homebrew/share/zsh-completions"
prune_dangling_symlinks "/usr/local/share/zsh/site-functions"
prune_dangling_symlinks "/usr/local/share/zsh-completions"

# Rebuild completion cache from scratch to avoid stale compdump entries.
rm -f "$HOME/.zcompdump" "$HOME/.zcompdump.zwc" "$HOME/.zcompdump"-*

zsh -c "FPATH=\"$ZSH_SITE_FUNCS:\$FPATH\"; autoload -Uz compinit >/dev/null 2>&1; compinit -d '$HOME/.zcompdump'"

echo "✅ zcompdump regenerated"
