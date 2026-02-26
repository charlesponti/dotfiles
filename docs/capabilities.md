# Setup Capabilities

This document describes what the new Ultimate 2026+ setup can do in practice.

## 1) One-command bootstrap
- `just setup` installs/syncs Homebrew dependencies, prepares tmux plugins, refreshes shell bundle/completion cache, and verifies runtime contract.
- Result: a new machine can move from baseline to usable dev state quickly.

## 2) Deterministic hybrid runtime
- Homebrew provides host-level tools and GUI apps.
- Nix flake provides reproducible project runtime definitions.
- `just runtime-check` validates that both layers are present and coherent.
- Result: local ergonomics without losing deterministic environments.

## 3) Profile-driven UX modes
- `./bin/ux-profile.sh core --exports`
- `./bin/ux-profile.sh power --exports`
- These map to `DOTFILES_PROFILE` and `DOTFILES_RUNTIME_MODE`.
- Result: explicit, scriptable behavior switching for shell/automation workflows.

## 4) High-performance shell interaction
- Fast zsh startup with measured budget enforcement.
- Fuzzy-first completion and cached completion behavior.
- Standardized editing/search keybindings and deterministic completion maintenance.
- Result: keyboard-first interaction with low latency and predictable behavior.

## 5) Prompt telemetry with budget gates
- `./bin/prompt-bench.sh` benchmarks prompt rendering for clean path and repo path contexts.
- `just perf` enforces shell startup and prompt rendering gates.
- Result: prompt quality can evolve without stealth performance regressions.

## 6) Tmux as workspace kernel
- `./bin/workspace-new.sh <name> <core|power>` provisions deterministic workspace layouts.
- `./bin/tmux-maintain.sh` ensures TPM and plugin sync are reproducible.
- Result: stable project sessions with repeatable pane/window structure.

## 7) Optional AI tooling availability
- `codex` and `opencode` CLIs are installed via `Brewfile`.
- Dotfiles do not include embedded AI workflow automation or wrappers.
- Result: tools are available, but workflow policy remains user/project-defined.

## 8) Fail-fast integrity checks
- Plugin lock parity is strict (missing/extra/duplicate entries fail).
- Runtime verification fails on missing prerequisites or invalid mode variables.
- Health/perf failures are explicit non-zero exits.
- Result: breakage is detected early, not after workflow drift.

## 9) Recovery path
- `tmux kill-server`
- `./bin/tmux-maintain.sh`
- `./bin/shell-maintain.sh`
- `exec zsh -l`
- Result: reproducible recovery sequence for restoring a healthy interactive environment.

## Capability matrix

| Area | Command(s) | Outcome |
|---|---|---|
| Bootstrap | `just setup` | End-to-end environment prep |
| Runtime integrity | `just runtime-check` | Hybrid runtime contract validated |
| Health | `just doctor` | System and policy diagnostics |
| Performance | `just perf` | Startup + prompt budget enforcement |
| AI tooling | `brew bundle` | `codex` and `opencode` CLI installed |
| Profile switching | `bin/ux-profile.sh` | Explicit behavior mode exports |
| Workspace provisioning | `bin/workspace-new.sh` | Deterministic tmux workspace |
| Recovery | hard reset sequence | Known-good baseline restoration |

## Who this setup is for
- Developers who want macOS-native speed and reliability.
- Teams that need reproducibility without sacrificing local UX.
- Power users who require measurable performance and clear operational contracts.
