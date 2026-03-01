#!/usr/bin/env bash

set -euo pipefail

source "$HOME/.dotfiles/bin/lib.sh"

PERF_MARGIN="0.15"
PERF_SHELL_P95_BUDGET_S="0.150"
PERF_GIT_STATUS_P95_BUDGET_S="0.250"
PERF_SEARCH_P95_BUDGET_S="0.200"
PERF_FS_P95_BUDGET_S="0.300"

CRITICAL_TOOLS=(git rg fd fzf zoxide mise uv docker bun node python3 direnv hyperfine watchexec air dlv gopls just)
SNAPSHOT_TOOLS=(zsh brew git bun node python3 go docker mise direnv hyperfine watchexec just)

REQUIRED_PATH=(
  "$HOME/.local/share/mise/shims"
  "$HOME/.dotfiles/bin"
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "/usr/local/bin"
  "/usr/local/sbin"
  "/usr/local/opt/python@3.12/libexec/bin"
  "/usr/local/opt/postgresql@15/bin"
  "$HOME/.cargo/bin"
  "$HOME/go/bin"
  "$HOME/.local/bin"
  "$HOME/.bun/bin"
  "$HOME/.cache/lm-studio/bin"
  "$HOME/.nix-profile/bin"
  "/nix/var/nix/profiles/default/bin"
  "$HOME/bin"
  "/usr/bin"
  "/usr/sbin"
  "/bin"
  "/sbin"
)

# the shellcheck stub is defined in the common helpers; keep the call so the
# arrays above appear used.
_diag_common_shellcheck_use
