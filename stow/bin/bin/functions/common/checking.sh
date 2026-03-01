#!/usr/bin/env bash
# Dependency and environment checking functions

# Check if a command is available
check_cmd() {
  if ! command -v "$1" &> /dev/null; then
    fail "$1 is required but not installed."
  fi
}

# Check if a command exists
check_command() {
    local cmd="$1"
    local description="$2"
    
    if command -v "$cmd" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $description"
    else
        echo -e "${RED}✗${NC} $description"
        ((ERRORS++))
    fi
}

# Check if a file exists
check_file() {
    local file="$1"
    local description="$2"
    
    if [[ -f "$file" ]]; then
        echo -e "${GREEN}✓${NC} $description"
    else
        echo -e "${RED}✗${NC} $description"
        ((ERRORS++))
    fi
}

# Check if a symlink exists and is valid
check_symlink() {
    local file="$1"
    local description="$2"
    
    if [[ -L "$file" ]]; then
        local target
        target=$(readlink "$file")
        if [[ -f "$target" ]]; then
            echo -e "${GREEN}✓${NC} $description"
        else
            echo -e "${YELLOW}⚠${NC} $description (broken symlink: $target)"
            ((WARNINGS++))
        fi
    else
        echo -e "${RED}✗${NC} $description"
        ((ERRORS++))
    fi
}
