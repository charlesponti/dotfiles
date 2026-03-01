# generic extractor, exported as function when sourced

extract() {
  if [[ ! -f "$1" ]]; then
    echo "'$1' is not a valid file"
    return 1
  fi

  # choose appropriate command and ensure it exists on PATH
  local cmd
  case "$1" in
    *.tar.bz2) cmd="tar xjf" ;;
    *.tar.gz) cmd="tar xzf" ;;
    *.bz2) cmd="bunzip2" ;;
    *.rar) cmd="unrar x" ;;
    *.gz) cmd="gunzip" ;;
    *.tar) cmd="tar xf" ;;
    *.tbz2) cmd="tar xjf" ;;
    *.tgz) cmd="tar xzf" ;;
    *.zip) cmd="unzip" ;;
    *.7z) cmd="7z x" ;;
    *) echo "'$1' cannot be extracted"; return 1 ;;
  esac

  local tool=${cmd%% *}
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "required tool '$tool' not found for extracting '$1'"
    return 1
  fi

  $cmd "$1"
}
