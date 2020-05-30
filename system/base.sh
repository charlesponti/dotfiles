#!/usr/bin/env bash

renamer () {
  rename -f $1 --remove-extension --append=$2
  # find . -name '*.less' -exec sh -c 'mv "$0" "${0%.less}.css"' {} \; 
}

download-urls () {
  wget -i $1
  cat $1 | xargs -n 1 curl -LO
}

# Download YouTube Audio
youtube-dl-audio () {
  youtube-dl \
    --download-archive downloaded.txt \
    --no-overwrites \
    -ict \
    --yes-playlist \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 \
    --socket-timeout 5 \
    $1
}

# Open current directory in GitKraken
kraken () {
  open -na 'GitKraken' --args -p $(pwd)
}

daily() {
  informer "Upgrading Homebrew packages..."
  brew upgrade

  informer "Cleaning up Homebrew..."
  brew cleanup

  informer "Sending Homebrew to the doctor..."
  brew doctor

  informer "Upgrading NPM modules..."
  npm update -g
}

#######################################
# Return list of processes listening on a given port
# Globals:
#   None
# Arguments:
#   $1 - port to search
# Returns:
#   None
#######################################
whos_listening() {
  lsof -nP -iTCP:$1
}
