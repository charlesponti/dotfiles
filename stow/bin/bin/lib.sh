#!/usr/bin/env bash

# Resolve dotfiles root directory
resolve_dotfiles_root() {
  if [[ -n "${DOTFILES:-}" ]]; then
    echo "$DOTFILES"
  elif [[ -d "${1:-}/../../../stow" ]]; then
    cd "${1:-}/../.." && pwd -P
  elif [[ -d "${1:-}/../stow" ]]; then
    cd "${1:-}" && pwd -P
  else
    echo "$HOME/.dotfiles"
  fi
}

# Dotfiles location
export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# XDG Defaults
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Colors
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export NC='\033[0m'

# Messaging functions
informer() {
  printf "\n[ %b..%b ] %s\n" "$BLUE" "$NC" "$1"
}

user() {
  printf "\n[ %b??%b ] %s\n" "$YELLOW" "$NC" "$1"
}

success() {
  printf "\n\r\033[2K  [ %bOK%b ] %s\n" "$GREEN" "$NC" "$1"
}

fail() {
  printf "\n\r\033[2K  [%bFAIL%b] %s\n" "$RED" "$NC" "$1"
  exit 1
}

log_info() {
    echo "[INFO] $*"
}

log_error() {
    echo "[ERROR] $*" >&2
}

# Counters used by check_* functions below; initialize here so ((++ERRORS))
# never evaluates to 0 (falsy) and exits under set -e on the first failure.
ERRORS=${ERRORS:-0}
WARNINGS=${WARNINGS:-0}

# Checking functions
check_cmd() {
  if ! command -v "$1" &> /dev/null; then
    fail "$1 is required but not installed."
  fi
}

check_command() {
    local cmd="$1"
    local description="$2"

    if command -v "$cmd" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $description"
    else
        echo -e "${RED}✗${NC} $description"
        ((++ERRORS))
    fi
}

check_file() {
    local file="$1"
    local description="$2"

    if [[ -f "$file" ]]; then
        echo -e "${GREEN}✓${NC} $description"
    else
        echo -e "${RED}✗${NC} $description"
        ((++ERRORS))
    fi
}

check_symlink() {
    local file="$1"
    local description="$2"

    if [[ -L "$file" ]]; then
        local target
        target=$(readlink "$file")
        if [[ "$target" != /* ]]; then
            target="$(cd "$(dirname "$file")" && pwd)/$target"
        fi
        if [[ -e "$target" ]]; then
            echo -e "${GREEN}✓${NC} $description"
        else
            echo -e "${YELLOW}⚠${NC} $description (broken symlink: $target)"
            ((++WARNINGS))
        fi
    else
        echo -e "${RED}✗${NC} $description"
        ((++ERRORS))
    fi
}
