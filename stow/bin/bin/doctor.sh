#!/usr/bin/env bash

set -euo pipefail

source "$HOME/.dotfiles/bin/diag-common.sh"

brewfile="$HOME/.dotfiles/Brewfile"
repo_file=$(managed_repo_file)

# Normalize PATH in non-interactive invocations so checks are shell-agnostic.
for p in "${REQUIRED_PATH[@]}"; do
  if [[ -d "$p" ]] && ! path_has_entry "$p"; then
    PATH="$p:$PATH"
  fi
done
export PATH

brew_present="false"
bundle_ok="false"
if command -v brew >/dev/null 2>&1; then
  brew_present="true"
  if brew bundle check --file "$brewfile" --verbose >/tmp/dotfiles-brew-check.out 2>/tmp/dotfiles-brew-check.err; then
    bundle_ok="true"
  fi
else
  echo "brew not installed" > /tmp/dotfiles-brew-check.err
fi

missing_tools=()
tool_status=()
for tool in "${CRITICAL_TOOLS[@]}"; do
  path=$(tool_path "$tool")
  present="true"
  if [[ "$path" == "MISSING" ]]; then
    present="false"
    missing_tools+=("$tool")
  fi
  tool_status+=("$tool|$present|$path")
done

missing_path=()
for p in "${REQUIRED_PATH[@]}"; do
  if [[ -d "$p" ]] && ! path_has_entry "$p"; then
    missing_path+=("$p")
  fi
done

brew_lines=()
while IFS= read -r line; do
  brew_lines+=("$line")
done < "$brewfile"
forbidden_entries=(
  'brew "docker-compose"'
  'cask "warp"'
  'cask "font-fira-code"'
  'cask "font-jetbrains-mono"'
  'cask "font-monaspace"'
  'cask "font-source-code-pro"'
)
forbidden_hits=()
for needle in "${forbidden_entries[@]}"; do
  if printf '%s\n' "${brew_lines[@]}" | grep -Fq "$needle"; then
    forbidden_hits+=("$needle")
  fi
done

terminal_count=$(printf '%s\n' "${brew_lines[@]}" | grep -Ec '^cask "(ghostty|warp|iterm2)"' || true)
font_count=$(printf '%s\n' "${brew_lines[@]}" | grep -Ec '^cask "font-' || true)
single_terminal_ok="false"
single_font_ok="false"
[[ "$terminal_count" == "1" ]] && single_terminal_ok="true"
[[ "$font_count" == "1" ]] && single_font_ok="true"

missing_tool_versions=()
missing_envrc=()
missing_justfile=()
if [[ -f "$repo_file" ]]; then
  while IFS= read -r r; do
    r=$(echo "$r" | sed 's/^\s*//;s/\s*$//')
    [[ -z "$r" || "$r" == \#* ]] && continue
    r=${r/#\~/$HOME}
    if [[ -d "$r" ]]; then
      [[ -f "$r/.tool-versions" ]] || missing_tool_versions+=("$r")
      [[ -f "$r/.envrc" ]] || missing_envrc+=("$r")
      [[ -f "$r/justfile" ]] || missing_justfile+=("$r")
    fi
  done < "$repo_file"
fi

shell_report=$(benchmark_file "shell-startup.json")
git_report=$(benchmark_file "git-and-search.json")
fs_report=$(benchmark_file "fs-io.json")

shell_p95=$(p95_from_json "$shell_report" 'zsh -i -c exit')
git_p95=$(p95_from_json "$git_report" 'git -C')
rg_p95=$(p95_from_json "$git_report" 'rg --files')
fs_p95=$(p95_from_json "$fs_report" 'fd ')

shell_gate=$(bool_with_margin "$shell_p95" "$PERF_SHELL_P95_BUDGET_S")
git_gate=$(bool_with_margin "$git_p95" "$PERF_GIT_STATUS_P95_BUDGET_S")
rg_gate=$(bool_with_margin "$rg_p95" "$PERF_SEARCH_P95_BUDGET_S")
fs_gate=$(bool_with_margin "$fs_p95" "$PERF_FS_P95_BUDGET_S")

echo "doctor-report:"
echo " - brew-present: $brew_present"
echo " - brew-bundle-check: $bundle_ok"
if [[ "$bundle_ok" != "true" ]]; then
  if [[ -s /tmp/dotfiles-brew-check.out ]]; then
    echo " - brew-bundle-output: $(tr '\n' ' ' </tmp/dotfiles-brew-check.out)"
  fi
  if [[ -s /tmp/dotfiles-brew-check.err ]]; then
    echo " - brew-bundle-error: $(tr '\n' ' ' </tmp/dotfiles-brew-check.err)"
  fi
fi

echo " - critical-tools:"
for row in "${tool_status[@]}"; do
  tool=${row%%|*}
  rest=${row#*|}
  present=${rest%%|*}
  path=${rest#*|}
  echo "   - $tool: present=$present path=$path"
done

if (( ${#missing_path[@]} > 0 )); then
  echo " - missing-path-entries:"
  for p in "${missing_path[@]}"; do
    echo "   - $p"
  done
fi

if (( ${#forbidden_hits[@]} > 0 )); then
  echo " - strict-profile forbidden-entries:"
  for f in "${forbidden_hits[@]}"; do
    echo "   - $f"
  done
fi

echo " - strict-profile single-terminal: $single_terminal_ok"
echo " - strict-profile single-font: $single_font_ok"

if [[ -f "$repo_file" ]]; then
  repos_count=$(grep -Evc '^\s*(#|$)' "$repo_file" || true)
  if [[ "$repos_count" != "0" ]]; then
    echo " - runtime-contract managed-repos: $repos_count"
  fi
fi

if (( ${#missing_tool_versions[@]} > 0 )); then
  echo " - runtime-contract missing .tool-versions:"
  for r in "${missing_tool_versions[@]}"; do
    echo "   - $r"
  done
fi
if (( ${#missing_envrc[@]} > 0 )); then
  echo " - runtime-contract missing .envrc:"
  for r in "${missing_envrc[@]}"; do
    echo "   - $r"
  done
fi
if (( ${#missing_justfile[@]} > 0 )); then
  echo " - runtime-contract missing justfile:"
  for r in "${missing_justfile[@]}"; do
    echo "   - $r"
  done
fi

echo " - perf-gate shell: $shell_gate p95=${shell_p95:-n/a}"
echo " - perf-gate git: $git_gate p95=${git_p95:-n/a}"
echo " - perf-gate search: $rg_gate p95=${rg_p95:-n/a}"
echo " - perf-gate fs: $fs_gate p95=${fs_p95:-n/a}"

ok="true"
[[ "$bundle_ok" == "true" ]] || ok="false"
(( ${#missing_tools[@]} == 0 )) || ok="false"
(( ${#missing_path[@]} == 0 )) || ok="false"
(( ${#forbidden_hits[@]} == 0 )) || ok="false"
[[ "$single_terminal_ok" == "true" ]] || ok="false"
[[ "$single_font_ok" == "true" ]] || ok="false"
(( ${#missing_tool_versions[@]} == 0 )) || ok="false"
(( ${#missing_envrc[@]} == 0 )) || ok="false"
(( ${#missing_justfile[@]} == 0 )) || ok="false"
[[ "$shell_gate" == "true" ]] || ok="false"
[[ "$git_gate" == "true" ]] || ok="false"
[[ "$rg_gate" == "true" ]] || ok="false"
[[ "$fs_gate" == "true" ]] || ok="false"

if [[ "$ok" == "true" ]]; then
  echo "doctor-status: PASS"
  exit 0
fi

echo "doctor-status: FAIL"
exit 1
