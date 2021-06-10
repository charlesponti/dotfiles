sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh `"
cd ~/.yadr
git pull --rebase
rake update
cd ~