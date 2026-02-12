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

echo "🔁 Regenerating zcompdump..."
ZSH_SITE_FUNCS="$HOME/.local/share/zsh/site-functions"
mkdir -p "$ZSH_SITE_FUNCS"

zsh -c "FPATH=\"$ZSH_SITE_FUNCS:\$FPATH\"; autoload -Uz compinit >/dev/null 2>&1; compinit -d '$HOME/.zcompdump'"

echo "✅ zcompdump regenerated"
