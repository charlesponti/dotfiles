# Ultimate 2026+ Dev Setup (Power User, Published)

## Intent
- Audience: power users consuming a public setup.
- Platform: macOS-first on Apple Silicon, Linux secondary.
- Runtime model: hybrid Homebrew + Nix.
- Innovation level: balanced.

## Core Architecture
- Homebrew owns system and GUI packages.
- Nix flakes own deterministic project runtimes.
- mise and direnv provide fast local ergonomics where full Nix is not required.
- zsh + tmux + Ghostty are the interactive runtime surface.

## Runtime Contract
- Global tools and desktop apps come from `Brewfile`.
- Reproducible project toolchains come from `flake.nix` + `flake.lock`.
- Project-local runtime selection wins over global PATH.
- `direnv` activation is explicit and guarded by `direnv allow`.

## Command Surface
- `just setup`: install/sync dependencies and bootstrap shell/tmux state.
- `just doctor`: environment diagnostics and policy checks.
- `just perf`: shell and prompt performance checks.
- `just runtime-check`: hybrid runtime contract verification.
- `bin/ux-profile.sh <core|power>`: emit profile exports.
- `bin/workspace-new.sh <name> <template>`: deterministic tmux workspace provisioning.

## Profile Model
- `core`: minimal and CI-safe.
- `power`: richer UX while preserving startup budget.

## Budgets
- Shell startup p95: `<= 120ms`.
- Prompt median render (warm): target `<= 8ms`, enforced local gate `<= 12ms`.

## Validation Gates
- Fail fast on plugin lock mismatch.
- Fail fast on shell startup budget breach.
- Fail fast when runtime contract checks fail.

## Recovery
- `tmux kill-server`
- `./bin/tmux-maintain.sh`
- `./bin/shell-maintain.sh`
- `exec zsh -l`
