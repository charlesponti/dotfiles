#!/usr/bin/env bash
# Git aliases and utilities

#=======================================================================
# BASIC GIT SHORTCUTS
#=======================================================================

# Branch operations
alias gb='git branch'
alias gbd='git branch -D'
alias gco='git checkout'
alias gsw='git switch'

# Repository operations
alias gcl='git clone'
alias gpl='git pull --all --prune'
alias gp='git push'
alias gpr='git prune'

# Commit operations
alias gc='git commit'
alias gca='git commit -a'
alias gcam='git commit -am'
alias gcanv='git commit -m $1 --no-verify'
alias gcaa='git commit -a --amend -C HEAD'  # Add uncommitted changes to last commit

# Status and information
alias gs='git status -sb'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gsl='git shortlog -sn'
alias gcount='git shortlog -sn'
alias gnew='git log HEAD@{1}..HEAD@{0}'  # Show commits since last pull

# Merge and reset
alias gm='git merge'
alias gus='git reset HEAD'

# Tags
alias gtls='git tag -l | gsort -V'

# Diff operations
alias gd='git diff'
alias gde='git diff'

# Archive
alias gexport='git archive --format zip --output'

#=======================================================================
# ADVANCED GIT FUNCTIONS
#=======================================================================

# Enhanced git diff with color
gdiff() {
  git --no-pager diff --color=auto --no-ext-diff --no-index "$@"
}

# Work In Progress: Add, commit, and push (for non-main/beta branches)
gitWIP() {
  local currentBranch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  
  if [ -z "$currentBranch" ]; then
    echo "❌ Not in a git repository"
    return 1
  fi

  if [ "$currentBranch" = "main" ] || [ "$currentBranch" = "beta" ] || [ "$currentBranch" = "master" ]; then
    echo "❌ Cannot use gitWIP on protected branch: $currentBranch"
    return 1
  fi

  echo "🔄 WIP commit on branch: $currentBranch"
  git add .
  git commit -m "wip" --no-verify
  git push origin "$currentBranch"
  echo "✅ WIP changes pushed to $currentBranch"
}

# Quick commit with message
gcommit() {
  if [ -z "$1" ]; then
    echo "Usage: gcommit <message>"
    return 1
  fi
  git add . && git commit -m "$1"
}

# Create and switch to new branch
gnewbranch() {
  if [ -z "$1" ]; then
    echo "Usage: gnewbranch <branch-name>"
    return 1
  fi
  git checkout -b "$1"
}

# Delete merged branches (excluding main, master, beta, develop)
gcleanup() {
  echo "🧹 Cleaning up merged branches..."
  git branch --merged | grep -v '\*\|main\|master\|beta\|develop' | xargs -n 1 git branch -d
  echo "✅ Cleanup complete"
}

# Show git status with helpful formatting
gstatus() {
  echo "📊 Git Repository Status"
  echo "======================="
  echo "Branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'Not a git repo')"
  echo "Remote: $(git remote get-url origin 2>/dev/null || echo 'No remote')"
  echo ""
  git status -sb
}

# Quick amend last commit
gamend() {
  git add . && git commit --amend --no-edit
}

# Show file history
ghistory() {
  if [ -z "$1" ]; then
    echo "Usage: ghistory <file>"
    return 1
  fi
  git log --follow -p -- "$1"
}


# Enhanced git log function with options
glog() {
  local usage="Usage: glog [options]
  Options:
      -h, --help     Show this help message
      -g, --graph    Show graph view
      -o, --oneline  Show each commit on one line
      -a, --author   Show author names
      -d, --date     Show relative dates
      -b, --branch   Show branch names and tags
  Example: glog -gab (graph view with authors and branches)"

  local show_graph=0
  local show_oneline=0
  local show_author=0
  local show_date=0
  local show_branch=0

  # Parse arguments
  for arg in "$@"; do
    case $arg in
      -h|--help) echo "$usage"; return 0 ;;
      -g|--graph) show_graph=1 ;;
      -o|--oneline) show_oneline=1 ;;
      -a|--author) show_author=1 ;;
      -d|--date) show_date=1 ;;
      -b|--branch) show_branch=1 ;;
    esac
  done

  # Build the git log command
  local cmd="git log"
  [[ $show_graph == 1 ]] && cmd+=" --graph"
  
  # Build the format string
  local format=""
  format+="%C(red)%h%C(reset)"  # Always show hash
  [[ $show_author == 1 ]] && format+=" %C(bold blue)<%an>%C(reset)"
  format+=" %s"  # Always show commit message
  [[ $show_branch == 1 ]] && format+=" %C(yellow)%d%C(reset)"
  [[ $show_date == 1 ]] && format+=" %C(green)(%cr)%C(reset)"

  if [[ $show_oneline == 1 ]]; then
    cmd+=" --pretty=oneline --abbrev-commit"
  else
    cmd+=" --pretty=format:'$format'"
  fi

  # Execute the command
  eval $cmd
}

#=======================================================================
# ADDITIONAL GIT ALIASES
#=======================================================================

# Undo and reset operations
alias gundo='git reset --soft HEAD~1'    # Undo last commit but keep changes
alias grh='git reset --hard'             # Hard reset
alias grs='git reset --soft'             # Soft reset
alias greset='git reset HEAD~1'          # Reset last commit

# Stash operations
alias gstash='git stash'
alias gstashp='git stash pop'
alias gstashl='git stash list'
alias gstashs='git stash show -p'

# Push operations
alias gpf='git push --force-with-lease'  # Safer force push

# Fetch and merge
alias gfm='git fetch && git merge'

# Branch management
alias gbc='git branch --show-current'    # Show current branch
alias gbr='git branch -r'                # Show remote branches
alias gba='git branch -a'                # Show all branches
alias gbm='git branch -m'                # Rename branch

# Log variations
alias glp='git log --patch'              # Show patches
alias gls='git log --stat'               # Show stats
alias glg='git log --graph --oneline --decorate --all'  # Graph view

# Clean operations
alias gclean='git clean -fd'             # Remove untracked files
alias gwip='gitWIP'                      # Shortcut for WIP function

# Search operations
alias gf='gfind'                         # Shortcut for gfind function

#=======================================================================
# UTILITY FUNCTIONS
#=======================================================================

# Fast commit with message
gccm() {
  if [ -z "$1" ]; then
    echo "Usage: gccm <commit-message>"
    return 1
  fi
  git add -A && git commit -m "$1"
}

# Show files changed in last commit
glast() {
  git diff --name-only HEAD~1 HEAD
}

# Find files in git history or search for content
gfind() {
  local usage="Usage: gfind [options] <search-term>
  Options:
      -f, --file     Find files by name pattern
      -c, --content  Search for content in commits
      -h, --help     Show this help message
  Examples:
      gfind -f '*.js'           # Find JavaScript files in history
      gfind -c 'function name'  # Search for content in commits"

  if [ $# -eq 0 ]; then
    echo "$usage"
    return 1
  fi

  local search_files=0
  local search_content=0
  local search_term=""

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      -f|--file)
        search_files=1
        shift
        ;;
      -c|--content)
        search_content=1
        shift
        ;;
      -h|--help)
        echo "$usage"
        return 0
        ;;
      *)
        search_term="$1"
        shift
        ;;
    esac
  done

  if [ -z "$search_term" ]; then
    echo "❌ Search term is required"
    echo "$usage"
    return 1
  fi

  if [[ $search_files == 1 ]]; then
    echo "🔍 Searching for files matching: $search_term"
    git log --all --pretty=format: --name-only --diff-filter=A | grep -E "$search_term" | sort -u
  elif [[ $search_content == 1 ]]; then
    echo "🔍 Searching for content: $search_term"
    git log --all -S "$search_term" --oneline
  else
    # Default: search both files and content
    echo "🔍 Searching for files and content matching: $search_term"
    echo ""
    echo "📁 Files:"
    git log --all --pretty=format: --name-only --diff-filter=A | grep -E "$search_term" | sort -u | head -10
    echo ""
    echo "📝 Commits with content:"
    git log --all -S "$search_term" --oneline | head -10
  fi
}

# Quick sync with upstream
gsync() {
  local current_branch=$(git branch --show-current)
  git checkout main 2>/dev/null || git checkout master 2>/dev/null
  git pull upstream main 2>/dev/null || git pull upstream master 2>/dev/null || git pull origin main 2>/dev/null || git pull origin master 2>/dev/null
  git checkout "$current_branch"
  git rebase main 2>/dev/null || git rebase master 2>/dev/null
}

# Remove large files from Git history using BFG Repo-Cleaner
gremove() {
  if [ -z "$1" ]; then
    echo "Usage: gremove <filename-or-pattern>"
    echo ""
    echo "Examples:"
    echo "  gremove large-file.csv"
    echo "  gremove '*.log'"
    echo "  gremove 'data/*.csv'"
    echo ""
    echo "This function will:"
    echo "  1. Create a backup clone"
    echo "  2. Use BFG to remove the file from history"
    echo "  3. Clean up the repository"
    echo "  4. Show you the commands to complete the process"
    return 1
  fi

  local filename="$1"
  local repo_name=$(basename "$(git rev-parse --show-toplevel)")
  local backup_name="${repo_name}-backup.git"
  
  # Check if we're in a git repository
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not in a git repository"
    return 1
  fi

  # Check if BFG is installed
  if ! command -v bfg &> /dev/null; then
    echo "❌ BFG Repo-Cleaner not found. Install it first:"
    echo "   brew install bfg"
    return 1
  fi

  echo "🗑️  Removing '$filename' from Git history..."
  echo ""
  
  # Step 1: Add to .gitignore if it's a specific file
  if [[ "$filename" != *"*"* ]] && [[ -f "$filename" ]]; then
    if ! grep -q "^$filename$" .gitignore 2>/dev/null; then
      echo "📝 Adding '$filename' to .gitignore"
      echo "" >> .gitignore
      echo "# Removed from Git history" >> .gitignore
      echo "$filename" >> .gitignore
      git add .gitignore
      git commit -m "Add $filename to .gitignore before removing from history"
    fi
  fi

  # Step 2: Create backup clone
  echo "📦 Creating backup clone..."
  cd .. || return 1
  
  if [ -d "$backup_name" ]; then
    echo "🗑️  Removing existing backup..."
    rm -rf "$backup_name"
  fi
  
  git clone --mirror "$repo_name" "$backup_name"
  
  # Step 3: Run BFG
  echo "🔧 Running BFG to remove '$filename'..."
  bfg --delete-files "$filename" "$backup_name"
  
  # Step 4: Clean up the backup
  echo "🧹 Cleaning up backup repository..."
  cd "$backup_name" || return 1
  git reflog expire --expire=now --all
  git gc --prune=now --aggressive
  
  # Step 5: Return to original repo and show next steps
  cd "../$repo_name" || return 1
  
  echo ""
  echo "✅ File removal complete! Next steps:"
  echo ""
  echo "1. Update your repository with cleaned history:"
  echo "   git remote set-url origin ../$backup_name"
  echo "   git fetch origin"
  echo "   git reset --hard origin/main"
  echo ""
  echo "2. Restore your remote URL (replace with your actual repo):"
  echo "   git remote set-url origin https://github.com/username/repo.git"
  echo ""
  echo "3. Force push the cleaned history:"
  echo "   git push --force-with-lease origin main"
  echo ""
  echo "4. Clean up backup:"
  echo "   rm -rf ../$backup_name"
  echo ""
  echo "⚠️  WARNING: After force pushing, all collaborators must re-clone the repository!"
}

# Quick version that does everything automatically (use with caution!)
gremove-auto() {
  if [ -z "$1" ]; then
    echo "Usage: gremove-auto <filename-or-pattern>"
    echo "⚠️  This will automatically apply changes and force push!"
    return 1
  fi

  local filename="$1"
  local repo_name=$(basename "$(git rev-parse --show-toplevel)")
  local backup_name="${repo_name}-backup.git"
  local original_remote=$(git remote get-url origin)
  
  echo "⚠️  AUTO MODE: This will automatically remove '$filename' and force push!"
  echo "Original remote: $original_remote"
  echo ""
  read -p "Are you sure? Type 'YES' to continue: " confirm
  
  if [ "$confirm" != "YES" ]; then
    echo "❌ Cancelled"
    return 1
  fi

  # Run the removal process
  gremove "$filename"
  
  # Auto-apply the changes
  echo "🤖 Auto-applying changes..."
  git remote set-url origin "../$backup_name"
  git fetch origin
  git reset --hard origin/main
  git remote set-url origin "$original_remote"
  
  echo "🚀 Force pushing cleaned history..."
  git push --force-with-lease origin main
  
  echo "🧹 Cleaning up backup..."
  rm -rf "../$backup_name"
  
  echo "✅ Auto-removal complete!"
}