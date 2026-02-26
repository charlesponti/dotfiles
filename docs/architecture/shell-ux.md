# Shell UX Architecture

## Stack
- Shell: `zsh`
- Completion UI: `fzf-tab` + zsh completion cache
- Navigation: `zoxide`
- Prompt: `starship`
- Session kernel: `tmux`
- Terminal: `Ghostty`

## Policies
- Keep plugin count low; each plugin must have measurable UX value.
- Maintain deterministic plugin lock parity (`antibody-plugins.txt` <-> `antibody-plugins.lock`).
- Preserve startup p95 budget while improving interaction quality.

## Keybinding Contract
- No global tmux bindings that collide with terminal typing behavior.
- Prefix-based tmux actions only for pane/window controls.
- zsh line editing uses standardized movement and history search bindings.

## Completion Contract
- Fuzzy-first completion.
- Grouped and cached completion results.
- Deterministic behavior after `./bin/shell-maintain.sh`.

## Profile Variables
- `DOTFILES_PROFILE=core|power`
- `DOTFILES_RUNTIME_MODE=hybrid|nix-heavy|brew-heavy`
