#!/usr/bin/env bash

set -euo pipefail

source "$HOME/.dotfiles/bin/diag-common.sh"

path="."
runs="20"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --path|-p)
      path="$2"
      shift 2
      ;;
    --runs|-r)
      runs="$2"
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

mkdir -p "$(bench_dir)"
report=$(benchmark_file "fs-io.json")
md=$(benchmark_file "fs-io.md")

if command -v fd >/dev/null 2>&1; then
  hyperfine --warmup 3 --runs "$runs" --export-json "$report" "fd . $path" "rg --files $path"
else
  hyperfine --warmup 3 --runs "$runs" --export-json "$report" "rg --files $path"
fi

fs_p95=$(p95_from_json "$report" 'fd ')
rg_p95=$(p95_from_json "$report" 'rg --files')
fs_ok=$(bool_under_budget "$fs_p95" "$PERF_FS_P95_BUDGET_S")
rg_ok=$(bool_under_budget "$rg_p95" "$PERF_SEARCH_P95_BUDGET_S")

status="PASS"
if [[ "$fs_ok" != "true" || "$rg_ok" != "true" ]]; then
  status="FAIL"
fi

{
  echo "# Filesystem Benchmark"
  echo
  echo "captured: $(date '+%Y-%m-%d %H:%M:%S %z')"
  echo "path: $path"
  echo "runs: $runs"
  echo "fd_p95_s: ${fs_p95:-n/a}"
  echo "fd_budget_s: $PERF_FS_P95_BUDGET_S"
  echo "rg_p95_s: ${rg_p95:-n/a}"
  echo "rg_budget_s: $PERF_SEARCH_P95_BUDGET_S"
  echo "status: $status"
} > "$md"

echo "fs p95-fd=${fs_p95:-n/a} budget=${PERF_FS_P95_BUDGET_S}s"
echo "fs p95-rg=${rg_p95:-n/a} budget=${PERF_SEARCH_P95_BUDGET_S}s"
