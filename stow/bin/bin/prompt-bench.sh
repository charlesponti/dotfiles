#!/usr/bin/env sh
set -eu

if ! command -v hyperfine >/dev/null 2>&1; then
  echo "hyperfine is required" >&2
  exit 1
fi

if ! command -v starship >/dev/null 2>&1; then
  echo "starship is required" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required" >&2
  exit 1
fi

runs="${1:-30}"
budget="${PROMPT_BUDGET_MS:-12}"
out="$(mktemp)"
out_git="$(mktemp)"
tmp_dir="$(mktemp -d)"
cleanup() {
  rm -f "$out" "$out_git"
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

STARSHIP_CONFIG="$HOME/.config/starship.toml" \
  hyperfine --warmup 5 --runs "$runs" --export-json "$out" --shell=none \
  "env STARSHIP_CONFIG=$HOME/.config/starship.toml starship prompt --path $tmp_dir" >/dev/null

STARSHIP_CONFIG="$HOME/.config/starship.toml" \
  hyperfine --warmup 5 --runs "$runs" --export-json "$out_git" --shell=none \
  "env STARSHIP_CONFIG=$HOME/.config/starship.toml starship prompt --path $PWD" >/dev/null

mean_ms="$(jq -r '.results[0].mean * 1000' "$out")"
median_ms="$(jq -r '.results[0].median * 1000' "$out")"
p95_ms="$(jq -r '.results[0].times | sort | .[(length*95/100|floor)] * 1000' "$out")"
git_median_ms="$(jq -r '.results[0].median * 1000' "$out_git")"

printf 'prompt-bench mean_ms=%.3f median_ms=%.3f p95_ms=%.3f\n' "$mean_ms" "$median_ms" "$p95_ms"
printf 'prompt-bench git_median_ms=%.3f\n' "$git_median_ms"

if awk "BEGIN {exit !($median_ms <= $budget)}"; then
  echo "prompt budget: PASS (median <= ${budget}ms)"
else
  echo "prompt budget: FAIL (median > ${budget}ms)"
  exit 1
fi
