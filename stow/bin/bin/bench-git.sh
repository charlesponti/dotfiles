#!/usr/bin/env bash

set -euo pipefail

source "$HOME/.dotfiles/bin/diag-common.sh"

repo="."
runs="20"
label="default"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo|-p)
      repo="$2"
      shift 2
      ;;
    --runs|-r)
      runs="$2"
      shift 2
      ;;
    --label|-l)
      label="$2"
      shift 2
      ;;
    *)
      echo "Unknown arg: $1" >&2
      exit 2
      ;;
  esac
done

if ! command -v hyperfine >/dev/null 2>&1; then
  fail "hyperfine not installed"
fi

if ! git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  fail "bench-git requires a git repository"
fi

mkdir -p "$(bench_dir)"
suffix=$(safe_label "$label")
[[ -z "$suffix" ]] && suffix="default"
base="git-and-search"
if [[ "$suffix" != "default" ]]; then
  base="git-and-search-$suffix"
fi
report=$(benchmark_file "$base.json")
md=$(benchmark_file "$base.md")

if command -v fd >/dev/null 2>&1; then
  hyperfine --warmup 3 --runs "$runs" --export-json "$report" \
    "git -C $repo status --porcelain" \
    "rg --files $repo" \
    "fd . $repo"
else
  hyperfine --warmup 3 --runs "$runs" --export-json "$report" \
    "git -C $repo status --porcelain" \
    "rg --files $repo"
fi

git_p95=$(p95_from_json "$report" 'git -C .* status --porcelain')
rg_p95=$(p95_from_json "$report" 'rg --files')
status="PASS"
if [[ $(bool_under_budget "$git_p95" "$PERF_GIT_STATUS_P95_BUDGET_S") != "true" ]]; then
  status="FAIL"
fi
if [[ $(bool_under_budget "$rg_p95" "$PERF_SEARCH_P95_BUDGET_S") != "true" ]]; then
  status="FAIL"
fi

{
  echo "# Git/Search Benchmark"
  echo
  echo "captured: $(date '+%Y-%m-%d %H:%M:%S %z')"
  echo "label: $suffix"
  echo "repo: $repo"
  echo "runs: $runs"
  echo "git_status_p95_s: $git_p95"
  echo "git_status_budget_s: $PERF_GIT_STATUS_P95_BUDGET_S"
  echo "search_p95_s: $rg_p95"
  echo "search_budget_s: $PERF_SEARCH_P95_BUDGET_S"
  echo "status: $status"
} > "$md"

echo "git-status p95=${git_p95}s budget=${PERF_GIT_STATUS_P95_BUDGET_S}s"
echo "search-rg p95=${rg_p95}s budget=${PERF_SEARCH_P95_BUDGET_S}s"

if [[ "$status" == "FAIL" ]]; then
  fail "git/search p95 budget exceeded"
fi
