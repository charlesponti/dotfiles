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