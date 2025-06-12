# dotfiles

> Personal dotfiles for macOS development environment

`dotfiles` are how you personalize your machine. These are mine.

Take and customize to your liking 💁

## Features

- 🚀 [Starship](https://starship.rs/) prompt with Git integration
- ⚡ [Zinit](https://github.com/zdharma-continuum/zinit) plugin manager
- 🔍 Enhanced Git workflow with custom aliases and functions
- 🛠️ Development tools setup (Node.js, Python, Docker, etc.)
- 💻 VS Code and Zed editor configurations
- 🍎 macOS system preferences automation
- 📁 Smart project initialization scripts

## Quick Overview

```
├── home/           # Dotfiles that get symlinked to ~/
├── system/         # Shell configuration modules
├── bin/            # Utility scripts and installers
├── commands/       # Custom shell commands
└── templates/      # Project templates
```

## Installation

### Fresh Installation (Recommended)

```bash
# One-liner installation
curl -s https://raw.githubusercontent.com/charlesponti/dotfiles/main/bootstrap.sh | bash
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
   ~/.dotfiles/bin/doctor.sh
   ```

3. **Install additional applications** (optional):
   ```bash
   brew bundle --file ~/.dotfiles/Brewfile
   ```

## Maintenance

### Update Everything
```bash
~/.dotfiles/update.sh
```

### Health Check
```bash
~/.dotfiles/bin/doctor.sh
```

### Install New Apps from Brewfile
```bash
brew bundle --file ~/.dotfiles/Brewfile
```

## Applications

- password manager 1Password
- browser Google Chrome
- code editor Visual Studio Code
- terminal Hyper
- containers [Docker](https://docs.docker.com/desktop/install/mac-install/)
- app management [SetApp](https://setapp.com/download)
  - CleanMyMac (Mac Management)
  - Ulysses (writing)
