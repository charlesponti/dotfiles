#!/usr/bin/env bash

#-----------------------
# Git
#-----------------------

alias gb='git branch'
alias gbd='git branch -D'
alias gco='git checkout'
alias gcl='git clone'
alias gc='git commit'
alias gca='git commit -a'
alias gcam='git commit -am'
alias gcanv='git commit -m $1 --no-verify'
# Add uncommitted and unstaged changes to the last commit
alias gcaa="git commit -a --amend -C HEAD"
# Show commits since last pull
alias gnew="git log HEAD@{1}..HEAD@{0}"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gm="git merge"
alias gpl='git pull --all --prune'
alias gp="git push"
alias gpr='git prune'
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias gsl="git shortlog -sn"
alias gsw="git switch"
alias gcount='git shortlog -sn'
alias gus="git reset HEAD"
alias gtls="git tag -l | gsort -V"
alias gd='git diff | mate'
alias gde="git diff | $EDITOR"
alias gexport='git archive --format zip --output'

gdiff() {
  git --no-pager diff --color=auto --no-ext-diff --no-index "$@"
}

# Function to add, commit, and push changes if the current branch is not "main" or "beta"
function gitWIP() {
  # Get the name of the current branch
  currentBranch=$(git rev-parse --abbrev-ref HEAD)

  # Check if the current branch is not "main" or "beta"
  if [ "$currentBranch" != "main" ] && [ "$currentBranch" != "beta" ]; then
    # Add all changes
    git add .

    # Commit changes with the message "wip" and skip pre-commit hooks (--no-verify)
    git commit -m "wip" --no-verify

    # Push changes to the remote repository
    git push
  fi
}

function glog() {
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

# Enhanced git aliases for productivity
alias gundo='git reset --soft HEAD~1'  # Undo last commit but keep changes
alias gwip='gitWIP'  # Shortcut for the WIP function
alias gclean='git clean -fd'  # Remove untracked files and directories
alias gstash='git stash'
alias gstashp='git stash pop'
alias gstashl='git stash list'
alias gstashs='git stash show -p'
alias grh='git reset --hard'  # Hard reset
alias grs='git reset --soft'  # Soft reset
alias greset='git reset HEAD~1'  # Reset last commit
alias gpf='git push --force-with-lease'  # Safer force push
alias gfm='git fetch && git merge'  # Fetch and merge
alias grib='git rebase -i'  # Interactive rebase
alias gsub='git submodule update --init --recursive'  # Update submodules

# Show git status with more info
alias gss='git status --porcelain=v1 --branch'

# Git log variations
alias glp='git log --patch'  # Show patches
alias gls='git log --stat'   # Show stats
alias glg='git log --graph --oneline --decorate --all'  # Graph view

# Branch management
alias gbc='git branch --show-current'  # Show current branch
alias gbr='git branch -r'  # Show remote branches
alias gba='git branch -a'  # Show all branches
alias gbm='git branch -m'  # Rename branch

# Work with commits
alias gcf='git commit --fixup'  # Create fixup commit
alias gcs='git commit --squash'  # Create squash commit
alias gcn='git commit --no-verify'  # Commit without hooks

# Fast commit with message
gccm() {
    git add -A && git commit -m "$1"
}

# Create and switch to new branch
gcob() {
    git checkout -b "$1"
}

# Delete merged branches (except main/master/develop)
gbd-merged() {
    git branch --merged | grep -v -E "(main|master|develop|\*)" | xargs -n 1 git branch -d
}

# Show files changed in last commit
glast() {
    git diff --name-only HEAD~1 HEAD
}

# Git ignore function - add files to .gitignore
gign() {
    echo "$1" >> .gitignore
}

# Quick sync with upstream
gsync() {
    current_branch=$(git branch --show-current)
    git checkout main 2>/dev/null || git checkout master 2>/dev/null
    git pull upstream main 2>/dev/null || git pull upstream master 2>/dev/null || git pull origin main 2>/dev/null || git pull origin master 2>/dev/null
    git checkout "$current_branch"
    git rebase main 2>/dev/null || git rebase master 2>/dev/null
}