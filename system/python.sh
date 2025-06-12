#!/usr/bin/env bash
# Python development utilities and aliases

#=======================================================================
# VIRTUAL ENVIRONMENT SHORTCUTS
#=======================================================================

alias venv='python3 -m venv'
alias activate='source venv/bin/activate || source .venv/bin/activate || source env/bin/activate'
alias deactivate='deactivate'

# Create and activate virtual environment in one command
mkenv() {
  local env_name=${1:-"venv"}
  python3 -m venv "$env_name"
  source "$env_name/bin/activate"
  echo "✅ Virtual environment '$env_name' created and activated"
}

#=======================================================================
# PIP SHORTCUTS
#=======================================================================

alias pip='pip3'
alias pipi='pip install'
alias pipu='pip install --upgrade'
alias pipir='pip install -r requirements.txt'
alias pipf='pip freeze'
alias pipfr='pip freeze > requirements.txt'
alias pipl='pip list'
alias pipo='pip list --outdated'

# Upgrade all pip packages
pip_upgrade_all() {
  echo "⬆️  Upgrading all pip packages..."
  pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U
  echo "✅ All pip packages upgraded"
}

#=======================================================================
# PYTHON SHORTCUTS
#=======================================================================

alias py='python3'
alias python='python3'
alias ipy='ipython'
alias jn='jupyter notebook'
alias jl='jupyter lab'

#=======================================================================
# DJANGO SHORTCUTS
#=======================================================================

alias djm='python manage.py'
alias djmm='python manage.py makemigrations'
alias djmi='python manage.py migrate'
alias djrs='python manage.py runserver'
alias djsh='python manage.py shell'
alias djcsu='python manage.py createsuperuser'
alias djct='python manage.py collectstatic'

#=======================================================================
# FLASK SHORTCUTS
#=======================================================================

alias flask-run='flask run'
alias flask-shell='flask shell'
alias flask-init='flask db init'
alias flask-migrate='flask db migrate'
alias flask-upgrade='flask db upgrade'

#=======================================================================
# TESTING SHORTCUTS
#=======================================================================

alias pytest='python -m pytest'
alias test='python -m pytest -v'
alias testc='python -m pytest --cov'
alias testx='python -m pytest -x'

#=======================================================================
# PYTHON DEVELOPMENT FUNCTIONS
#=======================================================================

# Setup Python environment with specified version
pyenv_setup() {
  local version=${1:-3.11}
  echo "🐍 Setting up Python $version development environment..."
  
  # Create virtual environment
  python3 -m venv venv
  source venv/bin/activate
  
  # Upgrade pip
  pip install --upgrade pip
  
  # Install common development tools
  pip install ipython jupyter pytest black flake8 mypy
  
  # Create basic project structure
  touch requirements.txt
  touch .env
  mkdir -p src tests docs
  
  # Create basic .gitignore
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
.env.*.local

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
  
  echo "✅ Python development environment setup complete!"
  echo "💡 Activate with: source venv/bin/activate"
}

# Quick Django project setup
django_init() {
  local project_name=${1:-myproject}
  echo "🌟 Creating Django project: $project_name"
  
  python3 -m venv venv
  source venv/bin/activate
  pip install django
  django-admin startproject "$project_name" .
  
  echo "✅ Django project created!"
  echo "💡 Run: python manage.py runserver"
}

# Quick Flask project setup
flask_init() {
  local project_name=${1:-myapp}
  echo "🌶️  Creating Flask project: $project_name"
  
  python3 -m venv venv
  source venv/bin/activate
  pip install flask
  
  cat > app.py << EOF
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, World!'

if __name__ == '__main__':
    app.run(debug=True)
EOF
  
  echo "✅ Flask project created!"
  echo "💡 Run: python app.py"
}

# Code quality tools
pycheck() {
  echo "🔍 Running Python code quality checks..."
  
  if command -v black >/dev/null 2>&1; then
    echo "  🎨 Formatting with black..."
    black .
  fi
  
  if command -v flake8 >/dev/null 2>&1; then
    echo "  🔍 Linting with flake8..."
    flake8 .
  fi
  
  if command -v mypy >/dev/null 2>&1; then
    echo "  🔬 Type checking with mypy..."
    mypy .
  fi
  
  if command -v pytest >/dev/null 2>&1; then
    echo "  🧪 Running tests..."
    pytest
  fi
  
  echo "✅ Code quality checks complete"
}

# Python environment information
pyinfo() {
  echo "🐍 Python Environment Information"
  echo "================================="
  echo "Python version: $(python --version)"
  echo "Python path: $(which python)"
  echo "Pip version: $(pip --version)"
  
  if [ -n "$VIRTUAL_ENV" ]; then
    echo "Virtual environment: $VIRTUAL_ENV"
    echo "Virtual env active: ✅"
  else
    echo "Virtual env active: ❌"
  fi
  
  echo "Installed packages: $(pip list | wc -l)"
  echo "Site packages: $(python -c 'import site; print(site.getsitepackages()[0])' 2>/dev/null || echo 'N/A')"
}