# Raycast configuration

This stow package manages your `~/.raycast` directory. Raycast stores its settings, extensions, snippets, and more under this folder.

* To enable the package run from the repo root:

```sh
stow -t ~ raycast
```

* Add your own Raycast files (e.g. `preferences.json`, `extensions/`, etc.) inside `.raycast/` and commit them.

### Sample script commands

The repository includes two script commands that use the Homebrew
`switchaudio-osx` utility to change CoreAudio devices from Raycast:

* `set-audio-output.sh` – switch output device
* `set-audio-input.sh` – switch input device

They live in `.raycast/scripts/` and will be discovered when you add
that folder in Raycast’s **Extensions → Script Commands** settings.

```sh
brew install switchaudio-osx    # provides the SwitchAudioSource CLI
chmod +x ~/.raycast/scripts/*.sh
```

The sample scripts contain static dropdowns; if you’d rather have
devices listed dynamically (works when you plug things in/out), edit
or replace the scripts accordingly.
