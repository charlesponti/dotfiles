#!/usr/bin/env bash

#-----------------------
# Git
#-----------------------

alias gb='git branch'
alias gc='git commit'
alias gca='git commit -a'
alias gcam='git commit -am'
alias gcanv='git commit -m $1 --no-verify'
# Add uncommitted and unstaged changes to the last commit
alias gcaa="git commit -a --amend -C HEAD"

alias gcl='git clone'
alias gco='git checkout'
alias gcount='git shortlog -sn'
alias gbd='git branch -D'
alias gexport='git archive --format zip --output'
alias gg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gl='git pull'
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gm="git merge"

# Fetch and merge upstream
alias gmu='git fetch origin -v; git fetch upstream -v; git merge upstream/master'

# From http://blogs.atlassian.com/2014/10/advanced-git-aliases/
# Show commits since last pull
alias gnew="git log HEAD@{1}..HEAD@{0}"

alias gp="git push"
alias gpl='git pull --all --prune'
alias gpr='git prune'
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias gsl="git shortlog -sn"
alias gus="git reset HEAD"

case $OSTYPE in
  darwin*)
    alias gtls="git tag -l | gsort -V"
    ;;
  *)
    alias gtls='git tag -l | sort -V'
    ;;
esac

if [ -z "$EDITOR" ]; then
  case $OSTYPE in
    linux*)
      alias gd='git diff | vim -R -'
      ;;
    darwin*)
      alias gd='git diff | mate'
      ;;
    *)
      alias gd='git diff'
      ;;
  esac
else
  # Remove `+` and `-` from start of diff lines; just rely upon color.
  # alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'
  alias gd="git diff | $EDITOR"
fi

#######################################
# Initialize a Git repository
# Globals:
#   HOME - Home directory
# Arguments:
#   None
# Returns:
#   None
#######################################
git-init() {
  # Initialize repository
  git init
  # Copy .gitignore
  cp $HOME/.dotfiles/home/.gitignore_global .gitignore
}

git-merge-main() {
  # Merge lastest main branch into current branch
  git co main && gpl && git co $1 && git merge main
}

gdiff() {
  git --no-pager diff --color=auto --no-ext-diff --no-index "$@"
}

# Replace the author and email of old commits. Very handy when updating someone's name and/or email.
# $1 - Original Author Name which will be replaced
# $2 - Name to replace original name with
# $3 - Email to replace original email with
git-rename-author() {
  git filter-branch --env-filter "if [ '$GIT_AUTHOR_NAME' = $1 ]; then
     GIT_AUTHOR_EMAIL=$2;
     GIT_AUTHOR_NAME=$1;
     GIT_COMMITTER_EMAIL=$2;
     GIT_COMMITTER_NAME=$1; fi" -f -- --all
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