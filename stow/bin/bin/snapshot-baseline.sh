#!/usr/bin/env bash

set -euo pipefail

source "$HOME/.dotfiles/bin/diag-common.sh"

outdir=$(report_dir)
mkdir -p "$outdir" "$(bench_dir)"
outfile="$outdir/machine-baseline.md"
now=$(date '+%Y-%m-%d %H:%M:%S %z')
os=$(sw_vers 2>/dev/null || true)
kern=$(uname -a 2>/dev/null || true)

{
  echo "# Machine Baseline"
  echo
  echo "Captured: $now"
  echo
  echo "## OS"
  echo '```'
  echo "$os"
  echo "$kern"
  echo '```'
  echo
  echo "## Toolchain"
  echo
  echo "| tool | path | version |"
  echo "| --- | --- | --- |"

  for tool in "${SNAPSHOT_TOOLS[@]}"; do
    path=$(tool_path "$tool")
    if [[ "$path" == "MISSING" ]]; then
      version="MISSING"
    else
      if [[ "$tool" == "go" ]]; then
        version=$(go version 2>&1 || true)
      else
        version=$($tool --version 2>&1 | head -n 1 || true)
      fi
      version=${version//$'\n'/ }
      version=${version//|/\\|}
    fi
    path=${path//|/\\|}
    echo "| $tool | $path | $version |"
  done
} > "$outfile"

echo "baseline-written: $outfile"
