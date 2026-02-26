#!/usr/bin/env bash

set -euo pipefail

source "$HOME/.dotfiles/bin/lib.sh"

PERF_MARGIN="0.15"
PERF_SHELL_P95_BUDGET_S="0.150"
PERF_GIT_STATUS_P95_BUDGET_S="0.250"
PERF_SEARCH_P95_BUDGET_S="0.200"
PERF_FS_P95_BUDGET_S="0.300"

CRITICAL_TOOLS=(git rg fd fzf zoxide mise uv docker bun node python3 direnv hyperfine watchexec air dlv gopls just)
SNAPSHOT_TOOLS=(zsh brew git bun node python3 go docker mise direnv hyperfine watchexec just)

REQUIRED_PATH=(
  "$HOME/.local/share/mise/shims"
  "$HOME/.dotfiles/bin"
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "/usr/local/bin"
  "/usr/local/sbin"
  "/usr/local/opt/python@3.12/libexec/bin"
  "/usr/local/opt/postgresql@15/bin"
  "$HOME/.cargo/bin"
  "$HOME/go/bin"
  "$HOME/.local/bin"
  "$HOME/.bun/bin"
  "$HOME/.cache/lm-studio/bin"
  "$HOME/.nix-profile/bin"
  "/nix/var/nix/profiles/default/bin"
  "$HOME/bin"
  "/usr/bin"
  "/usr/sbin"
  "/bin"
  "/sbin"
)

_diag_common_shellcheck_use() {
  : "$PERF_MARGIN" "$PERF_SHELL_P95_BUDGET_S" "$PERF_GIT_STATUS_P95_BUDGET_S" "$PERF_SEARCH_P95_BUDGET_S" "$PERF_FS_P95_BUDGET_S"
  : "${CRITICAL_TOOLS[*]}" "${SNAPSHOT_TOOLS[*]}" "${REQUIRED_PATH[*]}"
}

_diag_common_shellcheck_use

report_dir() {
  printf '%s\n' "$HOME/.dotfiles/reports"
}

bench_dir() {
  printf '%s\n' "$(report_dir)/bench"
}

managed_repo_file() {
  printf '%s\n' "$(report_dir)/managed-repos.txt"
}

bench_corpus_file() {
  printf '%s\n' "$(report_dir)/bench-corpus.txt"
}

benchmark_file() {
  printf '%s\n' "$(bench_dir)/$1"
}

safe_label() {
  local raw
  raw=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
  raw=$(printf '%s' "$raw" | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')
  printf '%s\n' "$raw"
}

p95_from_json() {
  local file="$1"
  local pattern="$2"

  if [[ ! -f "$file" ]]; then
    return 0
  fi

  python3 - "$file" "$pattern" <<'PY'
import json
import math
import re
import sys

file_path = sys.argv[1]
pattern = sys.argv[2]

try:
    with open(file_path, "r", encoding="utf-8") as fh:
        data = json.load(fh)
except Exception:
    print("")
    sys.exit(0)

matcher = re.compile(pattern)
for row in data.get("results", []):
    if matcher.search(row.get("command", "")):
        times = row.get("times", [])
        if not times:
            print("")
            sys.exit(0)
        times = sorted(float(t) for t in times)
        idx = int((len(times) - 1) * 95 / 100)
        print(f"{times[idx]:.6f}")
        sys.exit(0)

print("")
PY
}

bool_with_margin() {
  local value="$1"
  local budget="$2"
  python3 - "$value" "$budget" "$PERF_MARGIN" <<'PY'
import sys

value = sys.argv[1]
budget = float(sys.argv[2])
margin = float(sys.argv[3])
if value == "":
    print("true")
else:
    v = float(value)
    print("true" if v <= budget * (1.0 + margin) else "false")
PY
}

bool_under_budget() {
  local value="$1"
  local budget="$2"
  python3 - "$value" "$budget" <<'PY'
import sys

value = sys.argv[1]
budget = float(sys.argv[2])
if value == "":
    print("true")
else:
    v = float(value)
    print("true" if v <= budget else "false")
PY
}

path_has_entry() {
  local needle="$1"
  local cur="${PATH:-}"
  case ":$cur:" in
    *":$needle:"*) return 0 ;;
    *) return 1 ;;
  esac
}

tool_path() {
  local tool="$1"
  if command -v "$tool" >/dev/null 2>&1; then
    command -v "$tool"
  else
    printf 'MISSING\n'
  fi
}
