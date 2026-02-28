#!/usr/bin/env bash
set -euo pipefail

TPM_DIR="$HOME/.tmux/plugins/tpm"
TPM_REPO="https://github.com/tmux-plugins/tpm"
TMUX_CONF="$HOME/.tmux.conf"

if ! command -v tmux >/dev/null 2>&1; then
  echo "❌ tmux is required"
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "❌ git is required"
  exit 1
fi

if [[ ! -f "$TMUX_CONF" ]]; then
  echo "❌ $TMUX_CONF is required"
  exit 1
fi

mkdir -p "$(dirname "$TPM_DIR")"

if [[ ! -x "$TPM_DIR/tpm" ]]; then
  echo "📦 Installing TPM..."
  git clone --depth 1 "$TPM_REPO" "$TPM_DIR"
else
  echo "✅ TPM already installed"
fi

tmux start-server
tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins"
tmux source-file "$TMUX_CONF"

echo "🔧 Installing tmux plugins..."
"$TPM_DIR/bin/install_plugins"

echo "🔄 Updating tmux plugins..."
"$TPM_DIR/bin/update_plugins" all

echo "✅ tmux plugins are ready"
