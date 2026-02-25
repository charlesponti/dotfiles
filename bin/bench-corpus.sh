#!/usr/bin/env bash

set -euo pipefail

source "$HOME/.dotfiles/bin/diag-common.sh"

runs="20"
if [[ "${1:-}" == "--runs" || "${1:-}" == "-r" ]]; then
  runs="${2:-20}"
fi

corpus_file=$(bench_corpus_file)
if [[ ! -f "$corpus_file" ]]; then
  fail "bench-corpus requires entries in reports/bench-corpus.txt"
fi

rows=()
while IFS= read -r line; do
  line=$(echo "$line" | sed 's/^\s*//;s/\s*$//')
  [[ -z "$line" || "$line" == \#* ]] && continue

  label_raw="${line%%|*}"
  repo_raw="${line#*|}"
  label=$(safe_label "$(echo "$label_raw" | sed 's/^\s*//;s/\s*$//')")
  repo=$(echo "$repo_raw" | sed 's/^\s*//;s/\s*$//')
  repo=${repo/#\~/$HOME}

  echo "bench-corpus running label=${label} repo=${repo}"
  "$HOME/.dotfiles/bin/bench-git.sh" --repo "$repo" --runs "$runs" --label "$label"

  file=$(benchmark_file "git-and-search-${label}.json")
  git_p95=$(p95_from_json "$file" 'git -C')
  rg_p95=$(p95_from_json "$file" 'rg --files')
  rows+=("| $label | $repo | ${git_p95:-n/a} | ${rg_p95:-n/a} |")
done < "$corpus_file"

out=$(benchmark_file "corpus-summary.md")
{
  echo "# Corpus Benchmark Summary"
  echo
  echo "captured: $(date '+%Y-%m-%d %H:%M:%S %z')"
  echo
  echo "| label | repo | git_status_p95_s | search_p95_s |"
  echo "| --- | --- | --- | --- |"
  for row in "${rows[@]}"; do
    echo "$row"
  done
} > "$out"

echo "corpus-summary-written: $out"
