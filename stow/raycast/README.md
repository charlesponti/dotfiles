# Raycast configuration

This stow package manages your `~/.raycast` directory. Raycast stores its settings, extensions, snippets, and more under this folder.

* To enable the package run from the repo root:

```sh
stow -t ~ raycast
```

* Add your own Raycast files (e.g. `preferences.json`, `extensions/`, etc.) inside `.raycast/` and commit them.

### Script commands

Raycast script command implementations live in `stow/bin/bin/`.
The files in `.raycast/scripts/` are symlinks so Raycast can still
discover them from its expected script directory.

```sh
brew install switchaudio-osx    # provides the SwitchAudioSource CLI
chmod +x ~/.raycast/scripts/*.sh
```

Raycast-facing dotfiles maintenance commands:

* `dotfiles-status.sh` – one command with a Raycast dropdown for `summary`, `health`, `help`, or `dashboard`
* `dotfiles-shell-maintain.sh`
* `dotfiles-tmux-maintain.sh`
* `dotfiles-resource-scan.sh`
* `dotfiles-resource-guard.sh`
* `dotfiles-docx-to-md.sh` – convert the current Finder selection from `.docx` to `.md`
* `openspeek.sh` – convert a Markdown file path to AAC/M4A narration (Bun, in `~/Developer/toolbox/scripts/`; OpenRouter Flux TTS with piper/`say` fallback)

You can override command discovery with `DOTFILES_BIN_DIR`, and you can
override the checkout fallback path with `DOTFILES`.
