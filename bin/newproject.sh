#!/usr/bin/env bash
# Smart Project Initializer

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

show_usage() {
    echo -e "${BLUE}🚀 Smart Project Initializer${NC}"
    echo -e "${BLUE}=============================${NC}"
    echo
    echo "Usage: newproject <type> <name> [options]"
    echo
    echo "Project Types:"
    echo "  node       - Node.js/JavaScript project"
    echo "  react      - React application"
    echo "  next       - Next.js application"
    echo "  vue        - Vue.js application"
    echo "  python     - Python project"
    echo "  django     - Django web application"
    echo "  flask      - Flask web application"
    echo "  go         - Go application"
    echo "  rust       - Rust application"
    echo "  static     - Static HTML/CSS/JS website"
    echo
    echo "Examples:"
    echo "  newproject react my-app"
    echo "  newproject python data-analysis"
    echo "  newproject node api-server"
}

init_git_repo() {
    local project_name="$1"
    git init
    echo "# $project_name" > README.md
    echo "" >> README.md
    echo "A new project created with smart initializer." >> README.md
    git add .
    git commit -m "Initial commit"
    echo -e "${GREEN}✅ Git repository initialized${NC}"
}

create_node_project() {
    local name="$1"
    echo -e "${YELLOW}📦 Creating Node.js project: $name${NC}"
    
    mkdir -p "$name"
    cd "$name"
    
    npm init -y
    
    # Update package.json
    cat > package.json << EOF
{
  "name": "$name",
  "version": "1.0.0",
  "description": "A Node.js project",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js",
    "test": "jest",
    "lint": "eslint .",
    "format": "prettier --write ."
  },
  "keywords": [],
  "author": "",
  "license": "MIT"
}
EOF
    
    # Create basic structure
    cat > index.js << 'EOF'
console.log('Hello, World!');

// Your app code here
EOF
    
    mkdir -p src tests
    
    # Create .gitignore
    cat > .gitignore << 'EOF'
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
dist/
build/
*.log
.DS_Store
EOF
    
    init_git_repo "$name"
    echo -e "${GREEN}🎉 Node.js project created!${NC}"
    echo "Next steps: npm install express nodemon"
}

create_react_project() {
    local name="$1"
    echo -e "${YELLOW}⚛️  Creating React project: $name${NC}"
    
    if command -v npx >/dev/null 2>&1; then
        npx create-react-app "$name"
        cd "$name"
        echo -e "${GREEN}🎉 React project created!${NC}"
        echo "Next steps: npm start"
    else
        echo -e "${RED}❌ npx not found. Please install Node.js first.${NC}"
        return 1
    fi
}

create_next_project() {
    local name="$1"
    echo -e "${YELLOW}▲ Creating Next.js project: $name${NC}"
    
    if command -v npx >/dev/null 2>&1; then
        npx create-next-app@latest "$name" --typescript --tailwind --eslint
        cd "$name"
        echo -e "${GREEN}🎉 Next.js project created!${NC}"
        echo "Next steps: npm run dev"
    else
        echo -e "${RED}❌ npx not found. Please install Node.js first.${NC}"
        return 1
    fi
}

create_python_project() {
    local name="$1"
    echo -e "${YELLOW}🐍 Creating Python project: $name${NC}"
    
    mkdir -p "$name"
    cd "$name"
    
    # Create virtual environment
    python3 -m venv venv
    
    # Create project structure
    mkdir -p src tests docs
    touch src/__init__.py
    touch tests/__init__.py
    
    # Create requirements.txt
    cat > requirements.txt << 'EOF'
# Production dependencies

# Development dependencies (install with: pip install -r requirements-dev.txt)
EOF
    
    cat > requirements-dev.txt << 'EOF'
pytest>=7.0.0
black>=22.0.0
flake8>=4.0.0
mypy>=0.950
ipython>=8.0.0
jupyter>=1.0.0
EOF
    
    # Create main module
    cat > src/main.py << 'EOF'
"""Main module for the application."""

def main():
    """Main function."""
    print("Hello, Python!")

if __name__ == "__main__":
    main()
EOF
    
    # Create test
    cat > tests/test_main.py << 'EOF'
"""Tests for main module."""
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from main import main

def test_main():
    """Test main function."""
    # Your tests here
    pass
EOF
    
    # Create .gitignore
    cat > .gitignore << 'EOF'
# Virtual Environment
venv/
env/
.venv/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Environment
.env
.env.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Testing
.coverage
.pytest_cache/
htmlcov/

# Jupyter
.ipynb_checkpoints/
EOF
    
    # Create setup script
    cat > setup.py << EOF
"""Setup script for $name."""
from setuptools import setup, find_packages

setup(
    name="$name",
    version="0.1.0",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    python_requires=">=3.8",
    install_requires=[
        # Add your dependencies here
    ],
    extras_require={
        "dev": [
            "pytest>=7.0.0",
            "black>=22.0.0",
            "flake8>=4.0.0",
            "mypy>=0.950",
        ],
    },
)
EOF
    
    init_git_repo "$name"
    echo -e "${GREEN}🎉 Python project created!${NC}"
    echo "Next steps:"
    echo "  source venv/bin/activate"
    echo "  pip install -r requirements-dev.txt"
    echo "  python src/main.py"
}

create_go_project() {
    local name="$1"
    echo -e "${YELLOW}🐹 Creating Go project: $name${NC}"
    
    mkdir -p "$name"
    cd "$name"
    
    # Initialize Go module
    go mod init "$name"
    
    # Create main.go
    cat > main.go << 'EOF'
package main

import "fmt"

func main() {
    fmt.Println("Hello, Go!")
}
EOF
    
    # Create .gitignore
    cat > .gitignore << 'EOF'
# Go
*.exe
*.exe~
*.dll
*.so
*.dylib
*.test
*.out
go.work

# Dependency directories
vendor/

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# Environment
.env
.env.local
EOF
    
    init_git_repo "$name"
    echo -e "${GREEN}🎉 Go project created!${NC}"
    echo "Next steps: go run main.go"
}

create_static_project() {
    local name="$1"
    echo -e "${YELLOW}🌐 Creating static website: $name${NC}"
    
    mkdir -p "$name"
    cd "$name"
    
    # Create basic structure
    mkdir -p css js images
    
    # Create index.html
    cat > index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$name</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <h1>Welcome to $name</h1>
    </header>
    
    <main>
        <p>Your static website is ready!</p>
    </main>
    
    <footer>
        <p>&copy; 2025 $name</p>
    </footer>
    
    <script src="js/script.js"></script>
</body>
</html>
EOF
    
    # Create CSS
    cat > css/style.css << 'EOF'
/* Reset and base styles */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    line-height: 1.6;
    color: #333;
    background-color: #f4f4f4;
}

header {
    background-color: #2c3e50;
    color: white;
    text-align: center;
    padding: 2rem 0;
}

main {
    max-width: 800px;
    margin: 2rem auto;
    padding: 0 1rem;
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    padding: 2rem;
}

footer {
    text-align: center;
    padding: 1rem;
    background-color: #34495e;
    color: white;
    margin-top: 2rem;
}
EOF
    
    # Create JavaScript
    cat > js/script.js << 'EOF'
// Your JavaScript code here
console.log('Website loaded successfully!');

// Example: Add some interactivity
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM fully loaded');
});
EOF
    
    # Create .gitignore
    cat > .gitignore << 'EOF'
# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/

# Build artifacts
dist/
build/

# Environment
.env
.env.local

# Logs
*.log
EOF
    
    init_git_repo "$name"
    echo -e "${GREEN}🎉 Static website created!${NC}"
    echo "Next steps: open index.html in your browser"
}

main() {
    if [ $# -lt 2 ]; then
        show_usage
        return 1
    fi
    
    local project_type="$1"
    local project_name="$2"
    
    if [ -d "$project_name" ]; then
        echo -e "${RED}❌ Directory '$project_name' already exists${NC}"
        return 1
    fi
    
    case "$project_type" in
        node)
            create_node_project "$project_name"
            ;;
        react)
            create_react_project "$project_name"
            ;;
        next)
            create_next_project "$project_name"
            ;;
        python)
            create_python_project "$project_name"
            ;;
        go)
            create_go_project "$project_name"
            ;;
        static)
            create_static_project "$project_name"
            ;;
        *)
            echo -e "${RED}❌ Unknown project type: $project_type${NC}"
            show_usage
            return 1
            ;;
    esac
}

main "$@"
