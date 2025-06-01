# `brew install coreutils`
if $(ls &>/dev/null)
then
  # Open files in Visual Studio Code.
  alias c="code"
  
  # Simple clear command.
  alias cl='clear'

  alias g="git"
  alias k="kubectl"
  alias ll='eza -la --group-directories-first --git'

  alias zshconfig="code ~/.zshrc"
  alias dotfiles="code ~/.dotfiles"

  # Use Pygments for shell code syntax highlighting
  alias pcat='pygmentize -f terminal256 -O style=native -g'

  # Reload shell
  alias reload='source ~/.zshrc'

  # Delete all .DS_Store files
  alias noDS="sudo find / -name \".DS_Store\"  -exec rm {} \;"

  # Lists the ten most used commands.
  alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

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
  # Ruby
  #-----------------------
  alias bex='bundle exec'


  #-----------------------
  # Other
  #-----------------------

  # Disable sertificate check for wget.
  alias wget='wget --no-check-certificate'

  # Checks whether connection is up.
  alias net="ping ya.ru | grep -E --only-match --color=never '[0-9\.]+ ms'"

  # Pretty print json
  alias json='python -m json.tool'

  # Short-cuts for copy-paste.
  alias copy='pbcopy'
  alias paste='pbpaste'

  # Remove all items safely, to Trash (`brew install trash`).
  alias rm='trash'

  # Sniff network info.
  alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"

  # Case-insensitive pgrep that outputs full path.
  alias pgrep='pgrep -fli'

  jwt() {
    node -e "console.log(require('crypto').randomBytes(256).toString('base64'));"
  }

  #------------------------------------------------------------------------
  # Homebrew
  #------------------------------------------------------------------------
  # List all packages downloaded by Homebrew
  alias brews="brew list"
  # List all packages downloaded by brew cask
  alias casks="brew list --casks"
  # Install arm64 brew packages
  alias brew-arm="arch -arm64 brew"

  # Enhanced directory navigation
  alias ..='cd ..'
  alias ...='cd ../..'
  alias ....='cd ../../..'
  alias .....='cd ../../../..'
  alias ~='cd ~'
  alias -- -='cd -'
  
  # Better ls commands (if eza is available, fallback to ls)
  if command -v eza >/dev/null 2>&1; then
    alias l='eza -la --group-directories-first --git'
    alias ls='eza --group-directories-first'
    alias lt='eza --tree --level=2'
    alias lta='eza --tree --level=2 -a'
  else
    alias l='ls -lAh'
    alias ls='ls -GFh'
    alias ll='ls -l'
  fi
  
  # File operations
  alias cp='cp -iv'  # Interactive, verbose
  alias mv='mv -iv'  # Interactive, verbose
  alias mkdir='mkdir -pv'  # Create parent dirs, verbose
  
  # Find shortcuts
  alias ff='find . -type f -name'  # Find files
  alias fd='find . -type d -name'  # Find directories
  
  # Disk usage
  alias du='du -kh'    # Human readable
  alias df='df -kTh'   # Human readable
  
  # Process management
  alias ps='ps auxf'   # Full format
  alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'  # Search processes
  
  # Network
  alias ping='ping -c 5'  # Only ping 5 times
  alias fastping='ping -c 100 -s.2'  # Fast ping
  
  # Archive operations
  alias tarls='tar -tvf'    # List tar contents
  alias untar='tar -xf'     # Extract tar
  
  # Quick edit
  alias v='nvim'
  alias vi='nvim'
  alias vim='nvim'
  
  # File permissions
  alias chmod='chmod --preserve-root'
  alias chown='chown --preserve-root'
  
  # Memory and CPU
  alias meminfo='free -m -l -t'
  alias cpuinfo='lscpu'
  alias top='htop'
  
  # Show open ports
  alias ports='netstat -tulanp'
  
  # Weather (if curl is available)
  alias weather='curl -s wttr.in'
  
  # Quick file operations
  mkcd() { mkdir -p "$1" && cd "$1"; }  # Make directory and cd into it
  extract() {  # Universal extract function
    if [ -f "$1" ]; then
      case "$1" in
        *.tar.bz2)   tar xjf "$1"     ;;
        *.tar.gz)    tar xzf "$1"     ;;
        *.bz2)       bunzip2 "$1"     ;;
        *.rar)       unrar x "$1"     ;;
        *.gz)        gunzip "$1"      ;;
        *.tar)       tar xf "$1"      ;;
        *.tbz2)      tar xjf "$1"     ;;
        *.tgz)       tar xzf "$1"     ;;
        *.zip)       unzip "$1"       ;;
        *.Z)         uncompress "$1"  ;;
        *.7z)        7z x "$1"        ;;
        *)           echo "'$1' cannot be extracted via extract()" ;;
      esac
    else
      echo "'$1' is not a valid file"
    fi
  }
  
  # Quick backup function
  backup() { cp "$1"{,.bak}; }
  
  # Find and replace in files
  replace() {
    if [ $# -ne 3 ]; then
      echo "Usage: replace <search> <replace> <file_pattern>"
      return 1
    fi
    find . -name "$3" -type f -exec sed -i '' "s/$1/$2/g" {} +
  }

  # Quick help system
  alias help='$HOME/.dotfiles/bin/help.sh'
  alias perf='$HOME/.dotfiles/bin/terminal-performance.sh'

  # Development workflow shortcuts
  alias newproject='$HOME/.dotfiles/bin/newproject.sh'
  alias devenv='$HOME/.dotfiles/bin/devenv.sh'
  alias devinfo='$HOME/.dotfiles/bin/devenv.sh'
  alias setup='$HOME/.dotfiles/bin/devenv.sh --setup'

  # Quick project navigation and setup
  proj() {
      if [ -z "$1" ]; then
          echo "Current project info:"
          devenv
      else
          cd "$1" && devenv
      fi
  }

  # Terminal dashboard
  alias dashboard='$HOME/.dotfiles/bin/dashboard.sh'
  alias dash='$HOME/.dotfiles/bin/dashboard.sh'
  alias status='$HOME/.dotfiles/bin/dashboard.sh'
fi
