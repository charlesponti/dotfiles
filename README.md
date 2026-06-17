# dotfiles

> Personal dotfiles for macOS development environment

`dotfiles` are how you personalize your machine. These are mine.

Take and customize to your liking 💁

## Features

- 🚀 [Starship](https://starship.rs/) prompt tuned for low startup latency
- ⚡ [sheldon](https://sheldon.cli.rs/) as the plugin manager with a generated lockfile
- 🔍 Enhanced Git workflow with custom aliases and functions
- 🛠️ Development tools setup (Node.js, Python, Docker, etc.)
- 💻 VS Code and Zed editor configurations
- 📊 Unified status and health checking system

## Scripts

All script implementations live in `stow/bin/bin/`. Stowing the `bin` package exposes that same directory at `~/bin` on a new machine.

Common entry points:

- `stow/bin/bin/install.sh` / `stow/bin/bin/update.sh` - bootstrap or update the dotfiles repo.
- `stow/bin/bin/symlinks.sh` - stow configured packages into `$HOME`.
- `stow/bin/bin/status.sh` - summary, health, help, and dashboard views.
- `stow/bin/bin/runtime-verify.sh` - syntax and runtime smoke checks.
- `stow/bin/bin/shell-surface-audit.sh` - checks expected shell aliases/functions.
- `stow/bin/bin/shell-maintain.sh` / `stow/bin/bin/tmux-maintain.sh` - refresh shell and tmux support files.
- `stow/bin/bin/tmux-init.sh` - create or attach to a named tmux session.
- `stow/bin/bin/bench-shell.sh` - measure interactive zsh startup.
- `docx-to-md` / `stow/bin/bin/docx-to-md.sh` - convert `.docx` files to Markdown from any directory using pandoc.
- `stow/bin/bin/docx-to-md-selected.sh` - convert the current Finder selection (or explicit paths) to Markdown.
- `stow/bin/bin/resource-scan.sh` / `stow/bin/bin/resource-guard.sh` - inspect macOS memory/thermal pressure.
- `stow/bin/bin/hominem-db-snapshot.sh` - snapshot the local Hominem Postgres container.

Raycast-facing commands are prefixed with `dotfiles-`. Shared helpers are non-executable files in `stow/bin/bin/`.

Finder Quick Actions can also be managed from dotfiles via the `services` stow package (for example, `Convert DOCX to Markdown`).
