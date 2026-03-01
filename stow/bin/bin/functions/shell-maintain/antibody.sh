#!/usr/bin/env bash
# Antibody plugin management functions

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

prune_dangling_symlinks() {
  local dir="$1"
  [[ -d "$dir" ]] || return 0

  find "$dir" -type l -print0 2>/dev/null | while IFS= read -r -d '' link; do
    [[ -e "$link" ]] || rm -f "$link"
  done
}
