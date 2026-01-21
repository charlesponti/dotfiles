#!/usr/bin/env bash
# Quick help system for your dotfiles
# Usage: ./help.sh

set -euo pipefail

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

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
    echo "  usage           - Show disk usage for current directory"
    echo "  findlarge [size] - Find large files (default: 100M)"
    echo

    echo -e "${YELLOW}🔀 Git Shortcuts:${NC}"
    echo "  gs              - Git status (short format)"
    echo "  gco <branch>    - Checkout branch"
    echo "  gcob <branch>   - Create and checkout new branch"
    echo "  gccm <msg>      - Add all and commit with message"
    echo "  gwip            - Work in progress commit (safe branches only)"
    echo "  gundo           - Undo last commit (keep changes)"
    echo "  gsync           - Sync with upstream/origin main"
    echo "  gbd-merged      - Delete all merged branches"
    echo "  glast           - Show files changed in last commit"
    echo

    echo -e "${YELLOW}📦 Development:${NC}"
    echo "  pi <package>    - Smart package install (detects npm/yarn/pnpm/bun)"
    echo "  pr <script>     - Smart package run"
    echo "  ni              - npm install"
    echo "  nr <script>     - npm run"
    echo "  outdated        - Check outdated dependencies (all languages)"
    echo "  init_node <name> - Initialize Node.js project"
    echo "  init_python <name> - Initialize Python project"
    echo

    echo -e "${YELLOW}🐳 Docker:${NC}"
    echo "  dps             - docker ps"
    echo "  dex <container> - docker exec -it"
    echo "  dlog <container> - docker logs -f"
    echo "  dcu             - docker-compose up"
    echo "  dcd             - docker-compose down"
    echo

    echo -e "${YELLOW}🛠️ System Utilities:${NC}"
    echo "  sysinfo         - Show system information"
    echo "  killp <name>    - Kill process by name"
    echo "  httpstatus <url> - Check HTTP status of URL"
    echo "  genpass [length] - Generate random password"
    echo "  qr <text>       - Generate QR code"
    echo "  weather         - Show weather forecast"
    echo

    echo -e "${YELLOW}🔍 Search & Navigation:${NC}"
    echo "  google <terms>  - Search Google from terminal"
    echo "  ..              - cd .."
    echo "  ...             - cd ../.."
    echo "  l               - Enhanced ls with git info"
    echo "  lt              - Tree view (2 levels)"
    echo

    echo -e "${YELLOW}⚡ Performance:${NC}"
    echo "  terminal-performance - Run performance analysis"
    echo "  zsh-benchmark   - Benchmark ZSH startup time"
    echo "  reload          - Reload shell configuration"
    echo "  perf            - Quick performance check"
    echo

    echo -e "${YELLOW}🚀 Project Management:${NC}"
    echo "  newproject <type> <name> - Create new project (node, react, python, etc.)"
    echo "  devenv          - Detect and show project environment"
    echo "  setup           - Auto-setup project dependencies"
    echo "  dashboard       - Show terminal dashboard"
    echo "  dash            - Quick dashboard alias"
    echo "  status          - Project and system status"
    echo

    echo -e "${YELLOW}🐍 Python Development:${NC}"
    echo "  pyenv_setup     - Setup Python development environment"
    echo "  django_init     - Create Django project"
    echo "  flask_init      - Create Flask project"
    echo "  pycheck         - Run code quality checks"
    echo "  pyinfo          - Show Python environment info"
    echo "  pip_upgrade_all - Upgrade all pip packages"
    echo

    echo -e "${GREEN}💡 Pro Tips:${NC}"
    echo "• Most aliases support tab completion"
    echo "• Use 'help' to show this reference anytime"
    echo "• All tools use lazy loading for maximum speed"
    echo "• Your PATH is optimized and duplicate-free"
    echo
}

# If called with arguments, search for specific help
if [ $# -gt 0 ]; then
    echo -e "${YELLOW}Searching for: $*${NC}"
    show_help | grep -i "$*" --color=always
else
    show_help
fi
