#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ANTIBODY_PLUGINS="$ROOT_DIR/home/antibody-plugins.txt"
ANTIBODY_LOCK="$ROOT_DIR/home/antibody-plugins.lock"
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

normalize_plugins() {
  awk 'NF && $1 !~ /^#/ {print $1}' "$ANTIBODY_PLUGINS"
}

normalize_lock() {
  awk 'NF && $1 !~ /^#/ {print $1" "$2}' "$ANTIBODY_LOCK"
}

print_list() {
  local content="$1"
  while IFS= read -r line; do
    [[ -n "$line" ]] && echo " - $line"
  done <<< "$content"
}

build_antibody_bundle() {
  echo "🔧 Rebuilding antibody bundle..."
  antibody bundle < "$ANTIBODY_PLUGINS" > "$ANTIBODY_BUNDLE"
  echo "✅ Antibody bundle written to $ANTIBODY_BUNDLE"
}

ensure_antibody_lock() {
  command -v git >/dev/null 2>&1 || {
    echo "❌ git is required for antibody lock enforcement"
    exit 1
  }

  normalize_plugins > "$PLUGINS_LIST"
  normalize_lock > "$LOCK_LIST"

  if grep -nEv '^[^[:space:]]+ [0-9a-f]{40}$' "$LOCK_LIST" >/dev/null 2>&1; then
    echo "❌ Invalid lock format in $ANTIBODY_LOCK"
    grep -nEv '^[^[:space:]]+ [0-9a-f]{40}$' "$LOCK_LIST" || true
    exit 1
  fi

  plugin_dups="$(LC_ALL=C sort "$PLUGINS_LIST" | uniq -d || true)"
  if [[ -n "$plugin_dups" ]]; then
    echo "❌ Duplicate plugin entries in $ANTIBODY_PLUGINS:"
    print_list "$plugin_dups"
    exit 1
  fi

  awk '{print $1}' "$LOCK_LIST" > "$LOCK_PLUGINS"
  lock_dups="$(LC_ALL=C sort "$LOCK_PLUGINS" | uniq -d || true)"
  if [[ -n "$lock_dups" ]]; then
    echo "❌ Duplicate plugin entries in $ANTIBODY_LOCK:"
    print_list "$lock_dups"
    exit 1
  fi

  missing_plugins="$(comm -23 <(LC_ALL=C sort "$PLUGINS_LIST") <(LC_ALL=C sort "$LOCK_PLUGINS") || true)"
  if [[ -n "$missing_plugins" ]]; then
    echo "❌ Missing lock entries for plugins:"
    print_list "$missing_plugins"
    exit 1
  fi

  extra_locks="$(comm -13 <(LC_ALL=C sort "$PLUGINS_LIST") <(LC_ALL=C sort "$LOCK_PLUGINS") || true)"
  if [[ -n "$extra_locks" ]]; then
    echo "❌ Lock entries without matching plugins:"
    print_list "$extra_locks"
    exit 1
  fi

  join -j1 <(LC_ALL=C sort "$PLUGINS_LIST") <(LC_ALL=C sort "$LOCK_LIST") > "$LOCK_JOINED"

  echo "📌 Enforcing antibody plugin lock..."
  while IFS=' ' read -r plugin sha; do
    [[ -n "$plugin" && -n "$sha" ]] || continue

    plugin_dir="$(antibody path "$plugin" 2>/dev/null || true)"
    if [[ -z "$plugin_dir" || ! -d "$plugin_dir/.git" ]]; then
      echo "❌ Plugin checkout missing: $plugin"
      exit 1
    fi

    git -C "$plugin_dir" fetch --depth 1 origin "$sha" >/dev/null 2>&1
    git -C "$plugin_dir" checkout --detach "$sha" >/dev/null 2>&1

    current_sha="$(git -C "$plugin_dir" rev-parse HEAD)"
    if [[ "$current_sha" != "$sha" ]]; then
      echo "❌ Lock enforcement mismatch for plugin: $plugin"
      exit 1
    fi
  done < "$LOCK_JOINED"

  echo "✅ Antibody lock applied"
}

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

rm -f "$HOME/.zcompdump" "$HOME/.zcompdump.zwc" "$HOME/.zcompdump"-*

zsh -c "FPATH=\"$ZSH_SITE_FUNCS:\$FPATH\"; autoload -Uz compinit >/dev/null 2>&1; compinit -d '$HOME/.zcompdump'"

echo "✅ zcompdump regenerated"

if command -v zsh >/dev/null 2>&1; then
  echo "⚙️  Compiling zsh modules..."
  zsh -fc '
    for f in "$HOME/.dotfiles/system/"*.zsh "$HOME/.zshrc"; do
      [[ -f "$f" ]] || continue
      zcompile "$f"
    done
  ' >/dev/null 2>&1 || true
  echo "✅ zsh modules compiled"
fi
