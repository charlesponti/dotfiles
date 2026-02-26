# Nix Flake Policy

## Scope
- `flake.nix` defines deterministic developer runtime inputs.
- `flake.lock` pins exact upstream revisions and must be committed.

## Rules
- Any `flake.nix` dependency change requires `flake.lock` refresh.
- Keep shell hooks lightweight and deterministic.
- Use Nix for runtime/toolchain reproducibility, not GUI/system package management.

## Update Flow
- `nix flake lock`
- `./bin/runtime-verify.sh`
- `just perf`

## Review Requirements
- Lockfile diffs must be reviewed for input origin and revision age.
- Runtime contract docs must stay aligned with flake behavior.
