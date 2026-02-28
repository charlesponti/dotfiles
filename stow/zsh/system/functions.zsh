mkcd() {
  mkdir -p "$1" && cd "$1"
}

extract() {
  if [[ ! -f "$1" ]]; then
    echo "'$1' is not a valid file"
    return 1
  fi
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.7z) 7z x "$1" ;;
    *) echo "'$1' cannot be extracted"; return 1 ;;
  esac
}

sysinfo() {
  echo "$(uname -s) $(uname -r) $(uname -m)"
  echo "Uptime: $(uptime | awk '{print $3,$4}' | sed 's/,//')"
  if command -v sysctl >/dev/null 2>&1; then
    sysctl -n machdep.cpu.brand_string
  fi
}
