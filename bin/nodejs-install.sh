#!/usr/bin/env bash

# Install NVM
echo ""
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

echo ""
echo "Loading NVM..."
. "$HOME/.nvm/nvm.sh"

echo ""
echo "Installing stable..."
nvm install stable

echo ""
echo "Installing long-term service verison..."
nvm install lts/boron

echo ""
echo "Setting default to stable..."
nvm alias default stable

# npm install typescript -g

# For updating packages in a Node project
# npm install npm-check-updates -g

echo "Open new terminal window."