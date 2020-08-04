#!/usr/bin/env bash

dotfiles="$HOME/.dotfiles"

if [[ -d "$dotfiles" ]]; then
  echo "Symlinking dotfiles from $dotfiles"
else
  echo "$dotfiles does not exist"
  exit 1
fi

link() {
  echo "Linking '$1' to '$2'"
  rm -f "$2"
  ln -s "$1" "$2"
}

for location in $(find $HOME/.dotfiles/home -name '.*'); do
  file="${location##*/}"
  file="${file%.sh}"
  link "$location" "$HOME/$file"
done


# ------------------------------------------------------------------------------
# Visual Studio Code
# ------------------------------------------------------------------------------
VSCODE=$HOME/Library/"Application Support"/Code/User
VSCODE_BIN=$dotfiles/bin/vscode/User

# Remove snippets folder if one already exists
if [[ -d "$VSCODE/snippets" ]]; then
  rm -rf "$VSCODE/snippets"
fi

# Symlink VSCode settings
rm "$VSCODE/settings.json"
ln -snf $VSCODE_BIN/settings.json "$VSCODE"
ln -snf $VSCODE_BIN/snippets "$VSCODE"