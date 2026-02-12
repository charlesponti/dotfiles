#!/usr/bin/env bash
# Consolidated status and help system for dotfiles
# Usage: ./status.sh [health|help|dashboard|summary]

set -euo pipefail

# Load library
source "$HOME/.dotfiles/bin/lib.sh"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Unicode symbols
CHECK="✅"
CROSS="❌"
WARNING="⚠️"
INFO="ℹ️"
ROCKET="🚀"
GEAR="⚙️"
FOLDER="📁"

# Health check functions
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

show_health() {
    ERRORS=0
    WARNINGS=0
    
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
    echo "Summary:"
    if [[ $ERRORS -eq 0 && $WARNINGS -eq 0 ]]; then
        success "🎉 All checks passed! Your dotfiles are healthy."
    elif [[ $ERRORS -eq 0 ]]; then
        echo -e "${YELLOW}⚠ $WARNINGS warning(s) found, but no errors.${NC}"
    else
        echo -e "${RED}❌ $ERRORS error(s) and $WARNINGS warning(s) found.${NC}"
        echo -e "Consider running: ${YELLOW}~/.dotfiles/update.sh${NC}"
    fi
    
    return $ERRORS
}

show_help() {
    echo -e "${BLUE}🔧 Your Dotfiles Quick Reference${NC}"
    echo -e "${BLUE}================================${NC}"
    echo

    echo -e "${YELLOW}📁 File Operations:${NC}"
    echo "  mkcd <dir>      - Create directory and cd into it"
    echo "  backup <file>   - Quick backup with timestamp"
    echo "  extract <file>  - Universal archive extractor"
    echo "  ff <name>       - Find files by name"
    echo "  fd <name>       - Find directories by name"
    echo

    echo -e "${YELLOW}🔀 Git Shortcuts:${NC}"
    echo "  gs              - Git status (short format)"
    echo "  gco <branch>    - Checkout branch"
    echo "  gcob <branch>   - Create and checkout new branch"
    echo "  gccm <msg>      - Add all and commit with message"
    echo "  gwip            - Work in progress commit"
    echo "  gsync           - Sync with upstream/origin main"
    echo

    echo -e "${YELLOW}📦 Development:${NC}"
    echo "  pi <package>    - Smart package install"
    echo "  pr <script>     - Smart package run"
    echo "  outdated        - Check outdated dependencies"
    echo

    echo -e "${YELLOW}🛠️ System Utilities:${NC}"
    echo "  sysinfo         - Show system information"
    echo "  killp <name>    - Kill process by name"
    echo "  genpass [length] - Generate random password"
    echo

    echo -e "${YELLOW}🚀 Dotfiles Management:${NC}"
    echo "  make help       - Show dotfile commands"
    echo "  make doctor     - Run health check"
    echo "  make update     - Update dotfiles"
    echo "  make symlinks   - Refresh symlinks"
    echo
}

show_dashboard() {
    print_header() {
        echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║                    ${WHITE}🚀 DOTFILES STATUS${BLUE}                     ║${NC}"
        echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
        echo
    }

    print_header
    
    echo -e "${CYAN}${GEAR} Quick Status${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━${NC}"
    
    # Git status
    if [[ -d "$DOTFILES/.git" ]]; then
        cd "$DOTFILES"
        local git_status=$(git status --porcelain | wc -l | tr -d ' ')
        if [[ $git_status -eq 0 ]]; then
            echo -e "  Dotfiles repo: ${GREEN}Clean${NC}"
        else
            echo -e "  Dotfiles repo: ${YELLOW}$git_status uncommitted changes${NC}"
        fi
        cd - >/dev/null
    fi
    
    # Shell info
    echo -e "  Shell: ${GREEN}$SHELL${NC}"
    if [[ -n "$DOTFILES" ]]; then
        echo -e "  DOTFILES: ${GREEN}$DOTFILES${NC}"
    else
        echo -e "  DOTFILES: ${RED}Not set${NC}"
    fi
    
    # Disk usage
    local disk_usage=$(df -h / | awk 'NR==2{print $5}' | sed 's/%//')
    if [ "$disk_usage" -lt 80 ]; then
        echo -e "  Disk usage: ${GREEN}$disk_usage%${NC}"
    else
        echo -e "  Disk usage: ${RED}$disk_usage%${NC}"
    fi
    
    echo
    echo -e "${CYAN}${FOLDER} Quick Actions${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━${NC}"
    echo "  • Run './status.sh health' for detailed health check"
    echo "  • Run './status.sh help' for command reference"
    echo "  • Run 'make update' to update everything"
    echo
}

show_summary() {
    echo -e "${BLUE}🚀 Dotfiles Summary${NC}"
    echo -e "${BLUE}==================${NC}"
    echo
    
    # Basic status
    echo -e "${YELLOW}System Status:${NC}"
    echo "  Shell: $SHELL"
    echo "  Dotfiles: ${DOTFILES:-Not set}"
    
    # Quick health check
    if command -v git >/dev/null 2>&1 && command -v brew >/dev/null 2>&1; then
        echo -e "  Status: ${GREEN}✓ Core tools available${NC}"
    else
        echo -e "  Status: ${RED}✗ Missing core tools${NC}"
    fi
    
    echo
    echo -e "${YELLOW}Available Commands:${NC}"
    echo "  ./status.sh health    - Run health check"
    echo "  ./status.sh help      - Show command help"
    echo "  ./status.sh dashboard - Show dashboard"
    echo "  make help             - Show all commands"
    echo
}

# Main routing
case "${1:-summary}" in
    health)
        show_health
        ;;
    help)
        show_help
        ;;
    dashboard)
        show_dashboard
        ;;
    summary|"")
        show_summary
        ;;
    *)
        echo "Usage: $0 [health|help|dashboard|summary]"
        echo
        echo "  health    - Run comprehensive health check"
        echo "  help      - Show command reference"
        echo "  dashboard - Show status dashboard"
        echo "  summary   - Show quick summary (default)"
        exit 1
        ;;
esac