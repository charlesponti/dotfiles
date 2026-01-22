#!/usr/bin/env bash
# Health check script for dotfiles
# Usage: ./doctor.sh

set -euo pipefail

source "$HOME/.dotfiles/bin/lib.sh"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

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

check_symlink() {
    local file="$1"
    local description="$2"
    
    if [[ -L "$file" ]]; then
        local target=$(readlink "$file")
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

informer "🏥 Running dotfiles health check..."

echo
echo "Essential Commands:"
check_command "git" "Git is installed"
check_command "brew" "Homebrew is installed"
check_command "zsh" "Zsh is installed"
check_command "node" "Node.js is installed"
check_command "python3" "Python 3 is installed"
check_command "code" "VS Code CLI is available"
check_command "starship" "Starship prompt is installed"
check_command "mise" "Mise tool manager is installed"

echo
echo "Shell Configuration:"
check_symlink "$HOME/.zshrc" "Zsh configuration is symlinked"
check_symlink "$HOME/.gitconfig" "Git configuration is symlinked"
check_file "$HOME/.localrc" "Local configuration exists"

echo
echo "Git Configuration:"
if git config user.name >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Git user name is set: $(git config user.name)"
else
    echo -e "${RED}✗${NC} Git user name is not set"
    ((ERRORS++))
fi

if git config user.email >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Git user email is set: $(git config user.email)"
else
    echo -e "${RED}✗${NC} Git user email is not set"
    ((ERRORS++))
fi

echo
echo "Zinit Plugin Manager:"
if [[ -d "$HOME/.local/share/zinit" ]]; then
    echo -e "${GREEN}✓${NC} Zinit is installed"
else
    echo -e "${RED}✗${NC} Zinit is not installed"
    ((ERRORS++))
fi

echo
echo "Environment:"
if [[ "$SHELL" == */zsh ]]; then
    echo -e "${GREEN}✓${NC} Default shell is zsh"
else
    echo -e "${YELLOW}⚠${NC} Default shell is not zsh: $SHELL"
    ((WARNINGS++))
fi

if [[ -n "$DOTFILES" ]]; then
    echo -e "${GREEN}✓${NC} DOTFILES environment variable is set"
else
    echo -e "${YELLOW}⚠${NC} DOTFILES environment variable is not set"
    ((WARNINGS++))
fi

echo
echo "Summary:"
if [[ $ERRORS -eq 0 && $WARNINGS -eq 0 ]]; then
    success "🎉 All checks passed! Your dotfiles are healthy."
elif [[ $ERRORS -eq 0 ]]; then
    echo -e "${YELLOW}⚠ $WARNINGS warning(s) found, but no errors.${NC}"
else
    echo -e "${RED}❌ $ERRORS error(s) and $WARNINGS warning(s) found.${NC}"
    echo -e "Consider running: ${YELLOW}~/.dotfiles/update.sh${NC}"
fi

exit $ERRORS
