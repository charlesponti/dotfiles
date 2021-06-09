# Install ZSH & completions
brew install zsh zsh-completions zsh-autosuggestions

# Install Oh-My-Zsh
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

# Install Antigen
mkdir $HOME/.antigen
curl -L git.io/antigen > $HOME/.antigen/antigen.zsh

# Install Meslo font
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font

# Install Powerline Fonts
git clone https://github.com/powerline/fonts.git --depth=1;
cd fonts;
./install.sh;
cd ..;
rm -rf fonts;