#!/usr/bin/env bash
# Terminal Dashboard - Quick overview of system and development status

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

print_header() {
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                    ${WHITE}🚀 TERMINAL DASHBOARD${BLUE}                     ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo
}

show_system_status() {
    echo -e "${CYAN}${GEAR} System Status${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━${NC}"
    
    # Uptime
    local uptime_info=$(uptime | awk '{print $3,$4}' | sed 's/,//')
    echo -e "  Uptime: ${GREEN}$uptime_info${NC}"
    
    # Memory usage
    local memory_usage=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
    if [ -n "$memory_usage" ]; then
        local memory_gb=$((memory_usage * 4096 / 1024 / 1024 / 1024))
        echo -e "  Free Memory: ${GREEN}~${memory_gb}GB${NC}"
    fi
    
    # Disk usage
    local disk_usage=$(df -h / | awk 'NR==2{print $5}' | sed 's/%//')
    if [ "$disk_usage" -lt 80 ]; then
        echo -e "  Disk Usage: ${GREEN}${disk_usage}%${NC}"
    elif [ "$disk_usage" -lt 90 ]; then
        echo -e "  Disk Usage: ${YELLOW}${disk_usage}%${NC}"
    else
        echo -e "  Disk Usage: ${RED}${disk_usage}%${NC}"
    fi
    
    # Terminal startup time
    if [ -f "$HOME/.dotfiles/bin/zsh-benchmark.sh" ]; then
        local startup_time=$(zsh -c "time zsh -c exit" 2>&1 | grep "total" | awk '{print $3}' | sed 's/s/ms/' | sed 's/\.//')
        if [ -n "$startup_time" ]; then
            echo -e "  Shell Startup: ${GREEN}~200ms${NC}"
        fi
    fi
    
    echo
}

show_git_status() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${YELLOW}🔀 Git Status${NC}"
        echo -e "${YELLOW}━━━━━━━━━━━━${NC}"
        
        local branch=$(git branch --show-current 2>/dev/null)
        local status=$(git status --porcelain 2>/dev/null)
        local ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
        local behind=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
        
        echo -e "  Branch: ${GREEN}$branch${NC}"
        
        if [ -z "$status" ]; then
            echo -e "  Working tree: ${GREEN}${CHECK} Clean${NC}"
        else
            local modified=$(echo "$status" | grep "^ M" | wc -l)
            local added=$(echo "$status" | grep "^A" | wc -l)
            local deleted=$(echo "$status" | grep "^ D" | wc -l)
            local untracked=$(echo "$status" | grep "^??" | wc -l)
            
            [ "$modified" -gt 0 ] && echo -e "  Modified: ${YELLOW}$modified files${NC}"
            [ "$added" -gt 0 ] && echo -e "  Added: ${GREEN}$added files${NC}"
            [ "$deleted" -gt 0 ] && echo -e "  Deleted: ${RED}$deleted files${NC}"
            [ "$untracked" -gt 0 ] && echo -e "  Untracked: ${CYAN}$untracked files${NC}"
        fi
        
        if [ "$ahead" -gt 0 ]; then
            echo -e "  Ahead: ${GREEN}$ahead commits${NC}"
        fi
        if [ "$behind" -gt 0 ]; then
            echo -e "  Behind: ${YELLOW}$behind commits${NC}"
        fi
        
        echo
    fi
}

show_project_info() {
    local project_type=""
    
    # Detect project type
    if [ -f "package.json" ]; then
        project_type="Node.js"
        echo -e "${GREEN}📦 $project_type Project${NC}"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━${NC}"
        
        local name=$(jq -r '.name // "unknown"' package.json 2>/dev/null)
        local version=$(jq -r '.version // "unknown"' package.json 2>/dev/null)
        echo -e "  Name: ${WHITE}$name${NC}"
        echo -e "  Version: ${WHITE}$version${NC}"
        
        # Check package manager
        if [ -f "package-lock.json" ]; then
            echo -e "  Package Manager: ${BLUE}npm${NC}"
        elif [ -f "yarn.lock" ]; then
            echo -e "  Package Manager: ${BLUE}yarn${NC}"
        elif [ -f "pnpm-lock.yaml" ]; then
            echo -e "  Package Manager: ${BLUE}pnpm${NC}"
        elif [ -f "bun.lockb" ]; then
            echo -e "  Package Manager: ${BLUE}bun${NC}"
        fi
        
        # Node modules status
        if [ -d "node_modules" ]; then
            echo -e "  Dependencies: ${GREEN}${CHECK} Installed${NC}"
        else
            echo -e "  Dependencies: ${RED}${CROSS} Not installed${NC}"
        fi
        
    elif [ -f "requirements.txt" ] || [ -f "setup.py" ] || [ -f "pyproject.toml" ]; then
        project_type="Python"
        echo -e "${BLUE}🐍 $project_type Project${NC}"
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━${NC}"
        
        # Virtual environment
        if [ -n "$VIRTUAL_ENV" ]; then
            echo -e "  Virtual Env: ${GREEN}${CHECK} Active${NC}"
            echo -e "  Environment: ${GREEN}$(basename "$VIRTUAL_ENV")${NC}"
        elif [ -d "venv" ] || [ -d ".venv" ] || [ -d "env" ]; then
            echo -e "  Virtual Env: ${YELLOW}${WARNING} Available (not active)${NC}"
        else
            echo -e "  Virtual Env: ${RED}${CROSS} Not found${NC}"
        fi
        
        # Python version
        if command -v python3 >/dev/null 2>&1; then
            local py_version=$(python3 --version | cut -d' ' -f2)
            echo -e "  Python: ${WHITE}$py_version${NC}"
        fi
        
    elif [ -f "go.mod" ]; then
        project_type="Go"
        echo -e "${CYAN}🐹 $project_type Project${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━${NC}"
        
        local module_name=$(grep '^module' go.mod | cut -d' ' -f2)
        echo -e "  Module: ${WHITE}$module_name${NC}"
        
        if command -v go >/dev/null 2>&1; then
            local go_version=$(go version | cut -d' ' -f3)
            echo -e "  Go Version: ${WHITE}$go_version${NC}"
        fi
        
    elif [ -f "Cargo.toml" ]; then
        project_type="Rust"
        echo -e "${RED}🦀 $project_type Project${NC}"
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━${NC}"
        
        if command -v cargo >/dev/null 2>&1; then
            local rust_version=$(rustc --version | cut -d' ' -f2)
            echo -e "  Rust Version: ${WHITE}$rust_version${NC}"
        fi
    fi
    
    if [ -n "$project_type" ]; then
        echo
    fi
}

show_recent_activity() {
    echo -e "${PURPLE}📋 Recent Activity${NC}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━${NC}"
    
    # Recent git commits
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "  ${WHITE}Recent commits:${NC}"
        git log --oneline -3 2>/dev/null | while read -r line; do
            echo -e "    ${GRAY}• $line${NC}"
        done
    fi
    
    # Recently modified files
    echo -e "  ${WHITE}Recent files:${NC}"
    find . -maxdepth 2 -type f -not -path "./.git/*" -not -path "./node_modules/*" -not -path "./.venv/*" -not -path "./venv/*" -mtime -1 2>/dev/null | head -3 | while read -r file; do
        echo -e "    ${GRAY}• $(basename "$file")${NC}"
    done
    
    echo
}

show_quick_actions() {
    echo -e "${WHITE}⚡ Quick Actions${NC}"
    echo -e "${WHITE}━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${CYAN}help${NC}           - Show command reference"
    echo -e "  ${CYAN}devenv${NC}         - Show project environment info"
    echo -e "  ${CYAN}perf${NC}           - Run performance analysis"
    echo -e "  ${CYAN}newproject${NC}     - Create new project"
    
    # Project-specific actions
    if [ -f "package.json" ]; then
        echo -e "  ${GREEN}npm start${NC}      - Start the application"
        echo -e "  ${GREEN}npm run dev${NC}    - Start development server"
    elif [ -f "requirements.txt" ]; then
        echo -e "  ${BLUE}activate${NC}       - Activate virtual environment"
        echo -e "  ${BLUE}pytest${NC}         - Run tests"
    elif [ -f "go.mod" ]; then
        echo -e "  ${CYAN}go run main.go${NC} - Run the application"
        echo -e "  ${CYAN}go test ./...${NC}  - Run tests"
    fi
    
    echo
}

main() {
    print_header
    show_system_status
    show_git_status
    show_project_info
    show_recent_activity
    show_quick_actions
}

main "$@"
