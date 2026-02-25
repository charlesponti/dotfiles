# Runtime Determinism Contract (Managed Repos)

## Contract Surface
Each managed repository must contain:
- `.tool-versions` (runtime pinning via `mise`)
- `.envrc` (environment hydration via `direnv`)
- `justfile` (canonical loop interface)

## Enforcement Model
- Managed repo list source: `reports/managed-repos.txt`.
- `doctor` checks all existing listed paths.
- Missing `.tool-versions`, `.envrc`, or `justfile` is a hard failure.

## Bootstrap Procedure
1. Add repository path to `reports/managed-repos.txt`.
2. Copy templates from `reports/templates/repo-bootstrap/`.
3. Run `mise-sync` from repo root.
4. Run `direnv allow` once, then `envrc-load` from repo root.
5. Validate with `make doctor`.

## CI Parity
- Install and verify `just` in CI before running recipe targets.
- Reference template: `reports/templates/ci/just-bootstrap.sh`.
- Gate example: `command -v just >/dev/null || exit 1`.

## Non-Goals
- No implicit global runtime mutation.
- No fallback to unmanaged ad hoc version managers inside managed repos.
