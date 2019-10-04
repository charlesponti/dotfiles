# Install ZSH & completions
brew install zsh zsh-completions zsh-autosuggestions

# Install Oh-My-Zsh
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

# Install Powerline Fonts
git clone https://github.com/powerline/fonts.git --depth=1;
cd fonts;
./install.sh;
cd ..;
rm -rf fonts;