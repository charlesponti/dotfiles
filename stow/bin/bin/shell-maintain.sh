#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
ANTIBODY_PLUGINS="$ROOT_DIR/stow/zsh/antibody-plugins.txt"
ANTIBODY_LOCK="$ROOT_DIR/stow/zsh/antibody-plugins.lock"
ANTIBODY_BUNDLE="$HOME/.local/share/antibody/bundle.zsh"

mkdir -p "$(dirname "$ANTIBODY_BUNDLE")"

TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

PLUGINS_LIST="$TMP_DIR/plugins.txt"
LOCK_LIST="$TMP_DIR/lock.txt"
LOCK_PLUGINS="$TMP_DIR/lock-plugins.txt"
LOCK_JOINED="$TMP_DIR/joined.txt"

# Source functions
source "$SCRIPT_DIR/functions/common/messaging.sh"
source "$SCRIPT_DIR/functions/shell-maintain/antibody.sh"

if command -v antibody >/dev/null 2>&1 && [[ -f "$ANTIBODY_PLUGINS" ]]; then
  if [[ -f "$ANTIBODY_LOCK" ]]; then
    missing_checkout=0
    while IFS= read -r plugin || [[ -n "$plugin" ]]; do
      [[ -z "$plugin" || "$plugin" == \#* ]] && continue
      plugin_dir="$(antibody path "$plugin" 2>/dev/null || true)"
      if [[ -z "$plugin_dir" || ! -d "$plugin_dir/.git" ]]; then
        missing_checkout=1
        break
      fi
    done < "$ANTIBODY_PLUGINS"

    if [[ "$missing_checkout" -eq 1 ]]; then
      build_antibody_bundle
    fi

    ensure_antibody_lock
    build_antibody_bundle
  else
    build_antibody_bundle
  fi
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

prune_dangling_symlinks "$ZSH_SITE_FUNCS"
prune_dangling_symlinks "/opt/homebrew/share/zsh/site-functions"
prune_dangling_symlinks "/opt/homebrew/share/zsh-completions"
prune_dangling_symlinks "/usr/local/share/zsh/site-functions"
prune_dangling_symlinks "/usr/local/share/zsh-completions"

rm -f "$HOME/.zcompdump" "$HOME/.zcompdump.zwc" "$HOME/.zcompdump"-*

zsh -c "FPATH=\"$ZSH_SITE_FUNCS:\$FPATH\"; autoload -Uz compinit >/dev/null 2>&1; compinit -d '$HOME/.zcompdump'"

echo "✅ zcompdump regenerated"

if command -v zsh >/dev/null 2>&1; then
  echo "⚙️  Compiling zsh modules..."
  zsh -fc '
    for f in "$HOME/.dotfiles/stow/zsh/system/"*.zsh "$HOME/.zshrc"; do
      [[ -f "$f" ]] || continue
      zcompile "$f"
    done
  ' >/dev/null 2>&1 || true
  echo "✅ zsh modules compiled"
fi
