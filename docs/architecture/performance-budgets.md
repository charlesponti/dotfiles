# Performance Budgets

## Budget Targets
- Shell startup p95: `<= 120ms`
- Prompt median render (warm): target `<= 8ms`, enforced local gate `<= 12ms`

## Measurement Commands
- `./bin/bench-shell.sh --runs 20`
- `./bin/prompt-bench.sh`

## Gate Policy
- Any budget breach is a release blocker.
- Regressions must include a root-cause note and rollback path.

## Typical Regression Sources
- Prompt module expansion or expensive VCS status checks
- Excess plugin count or plugin load order changes
- completion cache invalidation loops
- per-prompt shell command substitutions

## Mitigation
- Keep prompt modules minimal and signal-dense.
- Prefer cached completion and deterministic maintenance scripts.
- Verify every UX change against shell and prompt budgets.
