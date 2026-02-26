# dotfiles

> Personal dotfiles for macOS development environment

`dotfiles` are how you personalize your machine. These are mine.

Take and customize to your liking 💁

## Features

- 🚀 [Starship](https://starship.rs/) prompt tuned for low startup latency
- ⚡ [Antibody](https://getantibody.github.io/) as the single plugin manager with a precompiled bundle
- 🔍 Enhanced Git workflow with custom aliases and functions
- 🛠️ Development tools setup (Node.js, Python, Docker, etc.)
- 💻 VS Code and Zed editor configurations
- 📊 Unified status and health checking system

## Quick Overview

```
├── home/           # Dotfiles that get symlinked to ~/
├── system/         # Shell configuration modules
├── bin/            # Utility scripts
└── .config/       # Application configurations
```

## Installation

### Fresh Installation (Recommended)

```bash
# One-liner bootstrap (clone + install)
curl -s https://raw.githubusercontent.com/charlesponti/dotfiles/main/install.sh | bash -s --bootstrap
```

### Manual Installation

1. **Prerequisites**: Ensure you have Xcode Command Line Tools installed:
   ```bash
   xcode-select --install
   ```

2. **Clone repository**:
   ```bash
   git clone https://github.com/charlesponti/dotfiles.git ~/.dotfiles
   ```

3. **Run installer**:
   ```bash
   cd ~/.dotfiles && ./install.sh
   ```

### Manual Installation

1. **Prerequisites**: Ensure you have Xcode Command Line Tools installed:
   ```bash
   xcode-select --install
   ```

2. **Clone the repository**:
   ```bash
   git clone https://github.com/charlesponti/dotfiles.git ~/.dotfiles
   ```

3. **Run the installer**:
   ```bash
   cd ~/.dotfiles && ./install.sh
   ```

### Post-Installation

1. **Restart your terminal** or source your shell configuration:
   ```bash
   source ~/.zshrc
   ```

2. **Run a health check**:
   ```bash
   ~/.dotfiles/bin/status.sh health
   ```

3. **Show available commands**:
   ```bash
   ~/.dotfiles/bin/status.sh help
   ```

## Maintenance

The repository includes a `Makefile` for easy management:

- `make help`: Show available commands
- `make update`: Update dotfiles and packages
- `make symlinks`: Refresh symlinks
- `make status`: Show dotfiles status overview
- `make doctor`: Run system health check

- `./bin/shell-maintain.sh`: Regenerate the antibody bundle, enforce plugin lock pins, regenerate zcompdump cache, and compile zsh modules
- `./bin/tmux-maintain.sh`: Install TPM if missing and run non-interactive tmux plugin install/update
- `./bin/bench-shell.sh`: Measure interactive startup (`zsh -i -c exit`) and enforce the latency budget

### Automation and Agent Workflow

- Interactive shell is `zsh`.
- Shell automation entrypoints are moving toward POSIX `sh` compatibility.
- Preferred command surface for humans and agents:
  - `make <target>`
  - `just <recipe>`
- Core diagnostics and benchmarking targets are implemented via `./bin/*.sh` and do not require any non-POSIX shell.
- Plugin source of truth is `home/antibody-plugins.txt`, pinned commits live in `home/antibody-plugins.lock`, and generated output is `~/.local/share/antibody/bundle.zsh`.
- `./bin/shell-maintain.sh` now enforces strict plugin/lock parity: no missing lock entries, no extra lock entries, no duplicates.
- `compinit -i` is used for startup stability and ignores insecure completion directory warnings; keep `fpath` trusted and refresh with `./bin/shell-maintain.sh`.
- `DOTFILES_ENABLE_MISE_HOOK=1` enables the full `mise` shell hook; default startup path uses `mise` shims only for faster prompt time.

### Hard Reset
```bash
tmux kill-server
./bin/tmux-maintain.sh
./bin/shell-maintain.sh
exec zsh -l
```

### Status Management
```bash
# Show summary
./bin/status.sh

# Run health check
./bin/status.sh health

# Show command help
./bin/status.sh help

# Show dashboard
./bin/status.sh dashboard
```

### Update Everything
```bash
./update.sh
```

### Health Check
```bash
# Run the built-in health check to verify your environment
~/.dotfiles/bin/status.sh health
```

### Contributing & local developer setup

If you contribute to this repo, please follow these steps to enable local secret scanning and pre-commit hooks so we don't accidentally commit credentials.

1) Enable the repository pre-commit hook
- Make the shipped hook executable and tell Git to use it:
  ```bash
  chmod +x .githooks/pre-commit
  git config core.hooksPath .githooks
  ```
  This will run a staged-file secret scan before each commit (it uses `gitleaks` if installed, otherwise a Docker fallback).

2) Install gitleaks locally (recommended)
- macOS (Homebrew):
  ```bash
  brew install gitleaks
  ```
- Or use the Docker fallback in the pre-commit hook; Docker must be available for that fallback to work.

3) Optional: install `jq` for nicer pre-commit output
- The pre-commit hook prints a redacted JSON report when it finds potential secrets. Installing `jq` makes the summary human-friendly:
  ```bash
  brew install jq
  ```

4) How the CI secret scan works
- A GitHub Actions workflow has been added (`.github/workflows/secret-scan.yml`) that runs `gitleaks` on pushes, pull requests, and weekly via cron.
- The job scans the full repository history and uploads a redacted JSON report as an artifact. The workflow will fail the PR if any findings are detected.

5) Running gitleaks manually (useful for audits)
- Full repo history scan (local):
  ```bash
  # with gitleaks installed
  gitleaks detect --source . --report-format json --redact --report-path gitleaks-report.json
  ```
- Scan a single file or directory:
  ```bash
  gitleaks detect --source path/to/dir_or_file --report-format json --redact --report-path report.json --no-git
  ```

6) If the hook flags something
- Investigate whether the finding is a false positive. If it's valid, remove the secret from the code and move it to an environment variable or secret manager, rotate the secret as necessary, and then re-commit.
- If it's a known benign finding you want to ignore globally, create a `.gitleaks.toml` baseline and consult the repo maintainers before committing it.

7) Notes for maintainers
- The CI workflow runs `gitleaks` in Docker to avoid installing additional binaries on runners.
- The pre-commit hook is intentionally permissive when neither `gitleaks` nor `docker` is available: it will skip scanning but prints a reminder to enable scanning.
- Consider enforcing `core.hooksPath` in developer onboarding docs or via an automated bootstrap script to ensure consistent local behavior.

Thank you for helping keep secrets out of the repository — these checks are intentionally conservative and redacted to avoid leaking sensitive values in build logs or artifacts.

### Health Check
```bash
./bin/doctor.sh
```

### Install New Apps from Brewfile
```bash
brew bundle --file ~/.dotfiles/Brewfile
```

## Core Tools

- **Package Management**: Homebrew with Brewfile
- **Shell**: Zsh with a performance-tuned Starship prompt, Antibody bundle, and cached zsh completions
- **Version Control**: Git with enhanced aliases and GitHub CLI
- **Development**: Node.js, Python 3, Docker
- **Editors**: VS Code, Zed (optional)
- **Terminal**: Custom aliases, functions, and smart PATH management
