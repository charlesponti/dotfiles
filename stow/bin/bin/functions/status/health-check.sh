#!/usr/bin/env bash
# Health check and status display functions

show_health() {
    ERRORS=0
    WARNINGS=0
    
    informer "🏥 Running dotfiles health check..."
    
    echo
    echo "Essential Commands:"
    check_command "git" "Git is installed"
    check_command "brew" "Homebrew is installed"
    check_command "zsh" "zsh is installed"
    check_command "node" "Node.js is installed"
    check_command "python3" "Python 3 is installed"
    check_command "code" "VS Code CLI is available"
    check_command "rg" "ripgrep is installed"
    check_command "fd" "fd is installed"
    check_command "fzf" "fzf is installed"
    check_command "watchexec" "watchexec is installed"
    check_command "hyperfine" "hyperfine is installed"
    check_command "mise" "mise tool manager is installed"
    check_command "direnv" "direnv is installed"
    
    echo
    echo "Shell Configuration:"
    check_symlink "$HOME/.zshrc" "Zsh configuration is symlinked"
    check_symlink "$HOME/.gitconfig" "Git configuration is symlinked"
    check_file "$HOME/.localrc" "Local configuration exists"

    echo
    echo "Brewfile Drift:"
    if brew bundle check --file "$HOME/.dotfiles/Brewfile" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Brewfile dependencies are converged"
    else
        echo -e "${RED}✗${NC} Brewfile drift detected (run: make brew-sync)"
        ((ERRORS++))
    fi

    echo
    echo "Doctor:"
    if "$HOME/.dotfiles/bin/doctor.sh" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Doctor checks passed"
    else
        echo -e "${RED}✗${NC} Doctor checks failed"
        ((ERRORS++))
    fi
    
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
    
    GEAR="⚙️"
    FOLDER="📁"
    WHITE='\033[1;37m'
    CYAN='\033[0;36m'

    echo -e "${CYAN}${GEAR} Quick Status${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━${NC}"
    
    # Git status
    if [[ -d "$DOTFILES/.git" ]]; then
        cd "$DOTFILES"
        local git_status
        git_status=$(git status --porcelain | wc -l | tr -d ' ')
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
    local disk_usage
    disk_usage=$(df -h / | awk 'NR==2{print $5}' | sed 's/%//')
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
}
