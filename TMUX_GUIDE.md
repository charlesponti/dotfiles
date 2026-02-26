# Tmux Advanced Configuration Guide

## Table of Contents

1. [Quick Start](#quick-start)
2. [Keybindings Reference](#keybindings-reference)
3. [Session Management](#session-management)
4. [Working with Windows and Panes](#working-with-windows-and-panes)
5. [Copy Mode and Clipboard](#copy-mode-and-clipboard)
6. [Plugin Management](#plugin-management)
7. [Session Templates](#session-templates)
8. [Ghostty Integration](#ghostty-integration)
9. [Troubleshooting](#troubleshooting)
10. [Customization](#customization)

---

## Quick Start

### First-Time Setup

1. **Run the symlink script** to create the tmux configuration:
   ```bash
   ~/.dotfiles/bin/symlinks.sh
   ```

2. **Start tmux** (from any terminal):
   ```bash
   tmux
   ```

3. **Install plugins** (press these keys):
   ```
   Ctrl+Space + I
   ```
   This installs all TPM plugins. You'll see progress in the status bar.

4. **Verify setup**:
   - Status bar should show session name, git branch, and time
   - Ctrl+Space should work as prefix
   - Vim-style navigation (h/j/k/l) should work in panes

### Basic Usage

```bash
# Start a new session
tmux new -s myproject

# List sessions
tmux ls

# Attach to a session
tmux attach -t myproject

# Detach from session (inside tmux)
Ctrl+Space + d

# Kill a session
tmux kill-session -t myproject
```

---

## Keybindings Reference

### Prefix Key
The prefix is **Ctrl+Space** (instead of the default Ctrl+b).

### Window Management

| Keybinding | Action |
|------------|--------|
| `Ctrl+Space + c` | Create new window |
| `Ctrl+Space + n` | Next window |
| `Ctrl+Space + p` | Previous window |
| `Ctrl+Space + w` | Choose window (list) |
| `Ctrl+Space + ,` | Rename current window |
| `Ctrl+Space + &` | Kill current window |
| `Ctrl+Space + 0-9` | Jump to window by number |

### Pane Navigation (Vim-Style)

| Keybinding | Action |
|------------|--------|
| `Ctrl+Space + h` | Navigate left |
| `Ctrl+Space + j` | Navigate down |
| `Ctrl+Space + k` | Navigate up |
| `Ctrl+Space + l` | Navigate right |

### Pane Resizing

| Keybinding | Action |
|------------|--------|
| `Ctrl+Space + H` | Resize left (5 cells) |
| `Ctrl+Space + J` | Resize down (5 cells) |
| `Ctrl+Space + K` | Resize up (5 cells) |
| `Ctrl+Space + L` | Resize right (5 cells) |

### Pane Splitting

| Keybinding | Action |
|------------|--------|
| `Ctrl+Space + \|` | Split vertically (left-right) |
| `Ctrl+Space + -` | Split horizontally (top-bottom) |
| `Ctrl+Space + z` | Toggle pane zoom |
| `Ctrl+Space + x` | Kill current pane |

### Session Management

| Keybinding | Action |
|------------|--------|
| `Ctrl+Space + s` | Choose session (list) |
| `Ctrl+Space + $` | Rename current session |
| `Ctrl+Space + d` | Detach from session |
| `Ctrl+Space + C` | New session (prompt for name) |
| `Ctrl+Space + (` | Previous session |
| `Ctrl+Space + )` | Next session |

### Copy Mode

| Keybinding | Action |
|------------|--------|
| `Ctrl+Space + [` | Enter copy mode |
| `Ctrl+Space + ]` | Paste from buffer |
| `Ctrl+Space + P` | Paste selection |

### Configuration

| Keybinding | Action |
|------------|--------|
| `Ctrl+Space + r` | Reload tmux config |
| `Ctrl+Space + ?` | Show all key bindings |

---

## Session Management

### Creating Sessions

```bash
# Create session in current directory
tmux new -s sessionname

# Create session in specific directory
tmux new -s sessionname -c /path/to/dir

# Create detached session (for automation)
tmux new -s sessionname -d
```

### Attaching and Detaching

```bash
# Attach to session
tmux attach -t sessionname

# Attach to last session
tmux attach

# Detach (inside tmux)
Ctrl+Space + d

# Detach others (let others stay attached)
tmux detach -a
```

### Session Persistence

This configuration includes **tmux-continuum** which automatically:
- Saves your session every 60 seconds
- Restores sessions when tmux starts

No manual action needed! Just close and reopen your terminal.

---

## Working with Windows and Panes

### Window Basics

```bash
# Create window
tmux new-window

# Rename window
tmux rename-window 'newname'

# List windows
tmux list-windows

# Switch to window
tmux select-window -t :0

# Kill window
tmux kill-window
```

### Pane Basics

```bash
# Split horizontally
tmux split-window

# Split vertically
tmux split-window -h

# Switch panes
tmux select-pane -L  # left
tmux select-pane -D  # down
tmux select-pane -U  # up
tmux select-pane -R  # right

# Resize pane
tmux resize-pane -L 5

# Kill pane
tmux kill-pane
```

### Layouts

```bash
# Even horizontal
tmux select-layout even-horizontal

# Even vertical
tmux select-layout even-vertical

# Main horizontal (one large pane)
tmux select-layout main-horizontal

# Tiled
tmux select-layout tiled
```

---

## Copy Mode and Clipboard

### Entering Copy Mode

1. Press `Ctrl+Space + [` to enter copy mode
2. Use vim keys to navigate:
   - `h/j/k/l` - move
   - `w/b` - word forward/backward
   - `gg/G` - beginning/end of buffer
   - `/` - search forward
   - `?` - search backward

### Selecting and Copying

1. Press `v` to start selection
2. Move to select text
3. Press `y` to copy (or `Enter`)
4. Press `q` to exit copy mode

### Pasting

- `Ctrl+Space + ]` - Paste from buffer
- `Ctrl+Space + P` - Paste with tmux-yank plugin

### System Clipboard

The **tmux-yank** plugin enables copying to system clipboard:
- In copy mode: `y` copies selection to clipboard
- Works with macOS clipboard automatically

---

## Plugin Management

### TPM (Tmux Plugin Manager)

This configuration includes these plugins:

| Plugin | Purpose |
|--------|---------|
| tmux-sensible | Sensible defaults |
| tmux-pain-control | Better pane navigation |
| tmux-resurrect | Save/restore sessions |
| tmux-continuum | Auto-save sessions |
| tmux-yank | Clipboard integration |
| tmux-open | Open URLs/files |
| tmux-prefix-highlight | Prefix indicator |
| catppuccin/tmux | Beautiful theme |

### Installing Plugins

```
Ctrl+Space + I
```

### Updating Plugins

```
Ctrl+Space + U
```

### Removing Plugins

1. Remove plugin from `~/.config/tmux/plugins.conf`
2. Press `Ctrl+Space + alt + u` to uninstall

---

## Session Templates

### Using the Template Script

The `tmux-sessions.sh` script creates pre-configured workspaces:

```bash
# Create web dev workspace
~/.dotfiles/bin/tmux-sessions.sh myproject dev

# Create in specific directory
~/.dotfiles/bin/tmux-sessions.sh myproject dev ~/Projects/myapp

# Create minimal session
~/.dotfiles/bin/tmux-sessions.sh minimal minimal

# List active sessions
~/.dotfiles/bin/tmux-sessions.sh list

# Attach to existing session
~/.dotfiles/bin/tmux-sessions.sh attach myproject
```

### Web Dev Template

Creates a workspace with:
- **Window 1: editor** - Split panes (67% editor, 33% command)
- **Window 2: server** - Run dev server
- **Window 3: logs** - Tail logs

---

## Ghostty Integration

### Automatic Setup

The Ghostty config (`~/.config/ghostty/config`) already includes:
```
command = ~/.dotfiles/bin/tmux-init.sh
```

This means:
1. Open Ghostty → tmux starts automatically
2. Close Ghostty → session persists
3. Reopen Ghostty → session restored

### Manual Setup (if needed)

Add to `~/.config/ghostty/config`:
```
command = ~/.dotfiles/bin/tmux-init.sh
```

Or with custom session:
```
command = ~/.dotfiles/bin/tmux-init.sh myproject
```

---

## Troubleshooting

### Config Not Loading

```bash
# Reload config manually
Ctrl+Space + r

# Or from terminal
tmux source-file ~/.tmux.conf
```

### Plugins Not Installing

```bash
# Check TPM is installed
ls ~/.tmux/plugins/tpm

# Reinstall TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Colors Not Displaying

Ensure your terminal supports 256 colors:
```bash
# Check TERM variable
echo $TERM

# Should show: screen-256color or tmux-256color
```

Add to `~/.tmux.conf`:
```tmux
set -g default-terminal "screen-256color"
```

### Session Not Restoring

```bash
# Check continuum status
tmux run -b 'echo $TMUX CONTINUUM STATUS'

# Manual restore
tmux run -b ~/.tmux/plugins/tmux-continuum/continuum-restore.sh
```

### Prefix Not Working

If Ctrl+Space doesn't work:
- Check if another app is capturing it
- Try: `Ctrl+Space` twice (sends literal Ctrl+Space)
- Verify config: `tmux list-keys | grep prefix`

### Performance Issues

- Reduce status bar refresh: `set -g status-interval 60`
- Disable mouse: `set -g mouse off`
- Check for many panes/windows

---

## Customization

### Changing the Theme

Edit `~/.config/tmux/plugins.conf`:
```tmux
# Change flavor
set -g @catppuccin_flavour 'latte'  # light theme
set -g @catppuccin_flavour 'mocha'  # dark theme (default)
set -g @catppuccin_flavour 'frappe'
set -g @catppuccin_flavour 'macchiato'
```

### Adding Custom Keybindings

Edit `~/.config/tmux/keybinds.conf`:
```tmux
# Example: Open file in VS Code
bind -n C-Space e split-window -h -c "#{pane_current_path}" "code ."
```

### Custom Status Bar

Edit `~/.config/tmux/status-bar.conf`:
```tmux
# Simpler right side
set -g status-right " %Y-%m-%d %H:%M "

# More detailed
set -g status-right " #{battery_percentage} | CPU: #{cpu_percentage} | %Y-%m-%d %H:%M "
```

### Session-Specific Settings

Create `~/.tmux.conf.local`:
```tmux
# These settings apply to all sessions

# Enable mouse
set -g mouse on

# Faster key repeat
set -g repeat-time 300
```

---

## Additional Resources

- [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)
- [Tmux Resurrect](https://github.com/tmux-plugins/tmux-resurrect)
- [Tmux Continuum](https://github.com/tmux-plugins/tmux-continuum)
- [Catppuccin Tmux](https://github.com/catppuccin/tmux)
- [Tmux Manual](https://man.openbsd.org/tmux.1)

---

## Configuration Files

This setup uses modular configuration:

| File | Purpose |
|------|---------|
| `~/.dotfiles/home/.tmux.conf` | Main config |
| `~/.dotfiles/.config/tmux/plugins.conf` | TPM plugins |
| `~/.dotfiles/.config/tmux/keybinds.conf` | Keybindings |
| `~/.dotfiles/.config/tmux/status-bar.conf` | Status bar |
| `~/.dotfiles/bin/tmux-init.sh` | Ghostty launcher |
| `~/.dotfiles/bin/tmux-sessions.sh` | Session templates |

---

## Quick Reference Card

```
PREFIX: Ctrl+Space

WINDOWS:      c new   n next   p prev   w list   , rename   & kill
PANE NAV:     h left  j down   k up     l right
PANE SIZE:    H left  J down   K up     L right  
PANE SPLIT:   | vert  - horiz  z zoom   x kill
SESSION:      s list  $ rename d detach  C new    ( prev   ) next
COPY:         [ mode  ] paste  P yank
CONFIG:       r reload ? help
PLUGINS:      I install  U update

INSTALL: Ctrl+Space + I
RELOAD: Ctrl+Space + r
DETACH: Ctrl+Space + d
```

---

*Last updated: February 2026*
*For issues, check the troubleshooting section or review your configuration files.*
