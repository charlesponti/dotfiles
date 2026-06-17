#!/usr/bin/env bash

set -euo pipefail

script_name=${0##*/}

die() {
  printf '%s: %s\n' "$script_name" "$1" >&2
  exit 1
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    die "missing required command: $1"
  fi
}

require_command gh

if ! gh auth status >/dev/null 2>&1; then
  die "gh is not authenticated. Run 'gh auth login' first."
fi

pr_data=$(gh pr view --json number,headRefName,headRefOid,url,baseRefName --jq '[.number, .headRefName, .headRefOid, .url, .baseRefName] | @tsv') || die "this branch does not have an open pull request"

IFS=$'\t' read -r pr_number head_ref head_sha pr_url base_ref <<<"$pr_data"

run_data=$(gh run list --branch "$head_ref" --event pull_request --limit 1 --json databaseId,attempt,status,conclusion,workflowName,url,headSha,createdAt --jq 'if length == 0 then empty else .[0] | [ .databaseId, .attempt, .status, .conclusion, .workflowName, .url, .headSha, .createdAt ] | @tsv end') || true

if [[ -z "${run_data//[$'\t\r\n ']/}" ]]; then
  die "no GitHub Actions runs were found for PR #$pr_number ($head_ref)"
fi

IFS=$'\t' read -r run_id attempt status conclusion workflow_name run_url run_sha created_at <<<"$run_data"

printf 'PR #%s: %s\n' "$pr_number" "$pr_url"
printf 'Branch: %s -> %s\n' "$head_ref" "$base_ref"
printf 'Latest run: %s\n' "$run_url"
printf 'Workflow: %s\n' "$workflow_name"
printf 'Status: %s\n' "$status"
printf 'Conclusion: %s\n' "${conclusion:-unknown}"
printf 'Commit: %s\n' "${run_sha:-$head_sha}"
printf 'Started: %s\n' "${created_at:-unknown}"
printf '\n'

if [[ "$status" != "completed" ]]; then
  printf 'The latest run is still %s, so there are no completed errors to show yet.\n' "$status"
  exit 2
fi

case "$conclusion" in
  success|neutral|skipped)
    printf 'The latest run did not fail.\n'
    exit 0
    ;;
  failure|cancelled|timed_out|startup_failure|action_required|*)
    printf 'Failed step logs:\n\n'
    gh run view "$run_id" --attempt "$attempt" --log-failed || gh run view "$run_id" --attempt "$attempt" --log
    ;;
esac
