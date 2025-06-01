#!/usr/bin/env bash
# Smart Development Environment Detection and Auto-Setup

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

detect_project_type() {
    local current_dir="$(pwd)"
    
    # Check for various project indicators
    if [ -f "package.json" ]; then
        echo "node"
    elif [ -f "requirements.txt" ] || [ -f "setup.py" ] || [ -f "pyproject.toml" ]; then
        echo "python"
    elif [ -f "go.mod" ]; then
        echo "go"
    elif [ -f "Cargo.toml" ]; then
        echo "rust"
    elif [ -f "composer.json" ]; then
        echo "php"
    elif [ -f "Gemfile" ]; then
        echo "ruby"
    elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
        echo "java"
    elif [ -f "index.html" ] && [ ! -f "package.json" ]; then
        echo "static"
    else
        echo "unknown"
    fi
}

auto_setup_env() {
    local project_type="$1"
    
    case "$project_type" in
        node)
            echo -e "${YELLOW}📦 Node.js project detected${NC}"
            if [ ! -d "node_modules" ]; then
                echo -e "${BLUE}Installing dependencies...${NC}"
                if [ -f "package-lock.json" ]; then
                    npm ci
                elif [ -f "yarn.lock" ]; then
                    yarn install
                elif [ -f "pnpm-lock.yaml" ]; then
                    pnpm install
                elif [ -f "bun.lockb" ]; then
                    bun install
                else
                    npm install
                fi
            fi
            ;;
        python)
            echo -e "${YELLOW}🐍 Python project detected${NC}"
            if [ ! -d "venv" ] && [ ! -d ".venv" ] && [ ! -d "env" ]; then
                echo -e "${BLUE}Creating virtual environment...${NC}"
                python3 -m venv venv
            fi
            if [ -f "requirements.txt" ]; then
                echo -e "${BLUE}Installing Python dependencies...${NC}"
                if [ -d "venv" ]; then
                    source venv/bin/activate
                elif [ -d ".venv" ]; then
                    source .venv/bin/activate
                elif [ -d "env" ]; then
                    source env/bin/activate
                fi
                pip install -r requirements.txt
            fi
            ;;
        go)
            echo -e "${YELLOW}🐹 Go project detected${NC}"
            echo -e "${BLUE}Downloading Go modules...${NC}"
            go mod tidy
            go mod download
            ;;
        rust)
            echo -e "${YELLOW}🦀 Rust project detected${NC}"
            echo -e "${BLUE}Building Rust project...${NC}"
            cargo build
            ;;
    esac
}

show_project_info() {
    local project_type="$1"
    local project_name="$(basename "$(pwd)")"
    
    echo -e "${GREEN}📊 Project Information${NC}"
    echo -e "${GREEN}=====================${NC}"
    echo "Project: $project_name"
    echo "Type: $project_type"
    echo "Location: $(pwd)"
    
    case "$project_type" in
        node)
            if [ -f "package.json" ]; then
                echo "Package manager: $(detect_package_manager)"
                echo "Scripts available:"
                npm run 2>/dev/null | grep -A 20 "available via" | tail -n +2 | head -10
            fi
            ;;
        python)
            if [ -f "requirements.txt" ]; then
                echo "Dependencies: $(wc -l < requirements.txt) packages"
            fi
            if [ -n "$VIRTUAL_ENV" ]; then
                echo "Virtual env: ✅ Active"
            else
                echo "Virtual env: ❌ Not active"
            fi
            ;;
        go)
            if [ -f "go.mod" ]; then
                echo "Go version: $(go version | cut -d' ' -f3)"
                echo "Module: $(grep '^module' go.mod | cut -d' ' -f2)"
            fi
            ;;
    esac
    echo
}

detect_package_manager() {
    if [ -f "package-lock.json" ]; then
        echo "npm"
    elif [ -f "yarn.lock" ]; then
        echo "yarn"
    elif [ -f "pnpm-lock.yaml" ]; then
        echo "pnpm"
    elif [ -f "bun.lockb" ]; then
        echo "bun"
    else
        echo "npm (default)"
    fi
}

suggest_commands() {
    local project_type="$1"
    
    echo -e "${YELLOW}💡 Suggested commands:${NC}"
    
    case "$project_type" in
        node)
            echo "  npm start        - Start the application"
            echo "  npm run dev      - Start development server"
            echo "  npm test         - Run tests"
            echo "  npm run build    - Build for production"
            echo "  npm run lint     - Lint code"
            ;;
        python)
            echo "  python main.py   - Run main application"
            echo "  pytest           - Run tests"
            echo "  python -m pip install -e . - Install in development mode"
            echo "  black .          - Format code"
            echo "  flake8 .         - Lint code"
            ;;
        go)
            echo "  go run main.go   - Run the application"
            echo "  go test ./...    - Run tests"
            echo "  go build         - Build binary"
            echo "  go mod tidy      - Clean up dependencies"
            ;;
        rust)
            echo "  cargo run        - Run the application"
            echo "  cargo test       - Run tests"
            echo "  cargo build      - Build in debug mode"
            echo "  cargo build --release - Build for release"
            ;;
        static)
            echo "  python3 -m http.server 8000 - Serve locally"
            echo "  open index.html  - Open in browser"
            ;;
    esac
    echo
}

main() {
    local auto_setup=${1:-false}
    
    local project_type=$(detect_project_type)
    
    if [ "$project_type" = "unknown" ]; then
        echo -e "${YELLOW}❓ No known project type detected in current directory${NC}"
        echo "Try running 'newproject <type> <name>' to create a new project"
        return 0
    fi
    
    show_project_info "$project_type"
    
    if [ "$auto_setup" = "true" ] || [ "$auto_setup" = "--setup" ]; then
        auto_setup_env "$project_type"
    fi
    
    suggest_commands "$project_type"
}

# If called directly, run main
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
