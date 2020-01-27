# grc overides for ls
# Made possible through contributions from generous benefactors like
# `brew install coreutils`
if $(gls &>/dev/null)
then
  alias k="kubectl"
  alias d="docker"
  alias g="git"
  alias c="code"

  # alias l='colorls --group-directories-first --almost-all'
  # alias ll='colorls --group-directories-first --almost-all --long' # detailed list view
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
  alias zshconfig="code ~/.zshrc"
  alias ohmyzsh="code ~/.oh-my-zsh"
  alias dotfiles="code ~/.dotfiles"

  # Use Pygments for shell code syntax highlighting
  alias pcat='pygmentize -f terminal256 -O style=native -g'

  alias reload!='exec $SHELL -l'

  # Simple clear command.
  alias cl='clear'

  # Delete all .DS_Store files
  alias noDS="sudo find / -name \".DS_Store\"  -exec rm {} \;"

  # Lists the ten most used commands.
  alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

  # Faster NPM for europeans.
  alias npme='npm --registry http://registry.npmjs.eu'

  #-----------------------
  # Keys
  #-----------------------
  # Pipe my public key to my clipboard.
  alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

  # Add SSH key to Keychain
  alias sshkeychain="ssh-add -K ~/.ssh/id_rsa"

  # Get Fingerprint of SSH key
  alias ssh-fingerprint="ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub | awk '{print $2}'"

  #-----------------------
  # Postgres
  #-----------------------
  alias pg='postgres -D /usr/local/var/postgres'

  #-----------------------
  # ElasticSearch
  #-----------------------
  alias elastic="elasticsearch --config=/usr/local/opt/elasticsearch/config/elasticsearch.yml"

  #-----------------------
  # Ruby
  #-----------------------
  alias bex='bundle exec'

  #-----------------------
  # NGINX
  #-----------------------
  alias ngup='sudo nginx'
  alias ngdown='sudo nginx -s stop'
  alias ngre='sudo nginx -s stop && sudo nginx'
  alias nglog='tail -f /usr/local/var/log/nginx/access.log'
  alias ngerr='tail -f /usr/local/var/log/nginx/error.log'

  #-----------------------
  # Other
  #-----------------------

  # Add base .eslintrc to current directory
  alias editorconfig-init="cp ${dotfiles}/home/.editorconfig .editorconfig"

  # Empty OS X trash
  alias emptytrash="sudo rm -rf ~/.Trash/*"

  # Restart Mac
  alias restartmac="sudo shutdown -r now"

  # Create symlink
  alias symlink="ln -sfv $1 $2"

  # Disable sertificate check for wget.
  alias wget='wget --no-check-certificate'

  # Checks whether connection is up.
  alias net="ping ya.ru | grep -E --only-match --color=never '[0-9\.]+ ms'"

  # Pretty print json
  alias json='python -m json.tool'

  # Start selenium-server at supplied port
  alias selenium="selenium-server -p $1"

  # Short-cuts for copy-paste.
  alias copy='pbcopy'
  alias paste='pbpaste'

  # Remove all items safely, to Trash (`brew install trash`).
  alias rm='trash'

  # Case-insensitive pgrep that outputs full path.
  alias pgrep='pgrep -fli'

  # Lock current session and proceed to the login screen.
  alias lock='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

  # Sniff network info.
  alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"

  # Process grep should output full paths to binaries.
  alias pgrep='pgrep -fli'

  #------------------------------------------------------------------------
  # Homebrew
  #------------------------------------------------------------------------
  # List all packages downloaded by Homebrew
  alias brews="brew list"
  # Shorthand for 'brew cask'
  alias cask="brew cask"
  # List all packages downloaded by brew cask
  alias casks="brew cask list"

  #------------------------------------------------------------------------
  # Xcode
  #------------------------------------------------------------------------
  alias ios="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
  alias watchos="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator\ \(Watch\).app"
fi