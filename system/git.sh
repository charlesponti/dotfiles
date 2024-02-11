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
alias gg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
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