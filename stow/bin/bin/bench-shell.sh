#!/usr/bin/env bash

set -euo pipefail

source "$HOME/.dotfiles/bin/diag-common.sh"

runs="30"
if [[ "${1:-}" == "--runs" || "${1:-}" == "-r" ]]; then
  runs="${2:-30}"
fi

if ! command -v hyperfine >/dev/null 2>&1; then
  fail "hyperfine not installed"
fi

outdir=$(bench_dir)
mkdir -p "$outdir"
report=$(benchmark_file "shell-startup.json")
md=$(benchmark_file "shell-startup.md")

hyperfine --warmup 3 --runs "$runs" --export-json "$report" "zsh -i -c exit"

p95s=$(p95_from_json "$report" 'zsh -i -c exit')
mean=$(python3 - "$report" <<'PY'
import json
import sys
with open(sys.argv[1], 'r', encoding='utf-8') as fh:
    data = json.load(fh)
print(f"{float(data['results'][0]['mean']):.6f}")
PY
)

status="PASS"
if [[ $(bool_under_budget "$p95s" "$PERF_SHELL_P95_BUDGET_S") != "true" ]]; then
  status="FAIL"
fi

{
  echo "# Shell Benchmark"
  echo
  echo "captured: $(date '+%Y-%m-%d %H:%M:%S %z')"
  echo "runs: $runs"
  echo "mean_s: $mean"
  echo "p95_s: $p95s"
  echo "budget_s: $PERF_SHELL_P95_BUDGET_S"
  echo "status: $status"
} > "$md"

echo "shell-startup mean=${mean}s p95=${p95s}s budget=${PERF_SHELL_P95_BUDGET_S}s"
if [[ "$status" == "FAIL" ]]; then
  fail "shell startup p95 budget exceeded"
fi
