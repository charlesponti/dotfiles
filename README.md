# dotfiles

> Personal dotfiles for macOS development environment

`dotfiles` are how you personalize your machine. These are mine.

Take and customize to your liking 💁

## Features

- 🚀 [Starship](https://starship.rs/) prompt with Git integration
- ⚡ [Antibody](https://getantibody.github.io/) plugin bundle (precompiled for fast startup)
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

- `./bin/shell-maintain.sh`: Regenerate the antibody bundle and zcompdump cache after adding/removing plugins or completions

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
./bin/doctor.sh
```

### Install New Apps from Brewfile
```bash
brew bundle --file ~/.dotfiles/Brewfile
```

## Core Tools

- **Package Management**: Homebrew with Brewfile
- **Shell**: Zsh with Starship prompt, Antibody bundle, and cached zsh completions
- **Version Control**: Git with enhanced aliases and GitHub CLI
- **Development**: Node.js, Python 3, Docker
- **Editors**: VS Code, Zed (optional)
- **Terminal**: Custom aliases, functions, and smart PATH management
