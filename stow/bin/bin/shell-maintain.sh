#!/usr/bin/env bash
set -euo pipefail

# make sure we can see binaries installed in ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"

# determine repo root (four levels above this script) and script dir
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

# Source functions
source "$SCRIPT_DIR/functions/common/messaging.sh"

if command -v sheldon >/dev/null 2>&1; then
  echo "🔁 Updating sheldon plugins..."
  sheldon lock --update
  echo "✅ Sheldon plugins updated"
else
  echo "⚠️  sheldon not found; run: brew install sheldon"
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
