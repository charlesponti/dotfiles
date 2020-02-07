#!/usr/bin/env bash

#-----------------------
# Git
#-----------------------

# Use Hub instead of Git
alias git=hub

# The rest of my fun git aliases
alias gac='git add -A && git commit -m'
alias gb='git branch'
alias gc='git commit'

# Add uncommitted and unstaged changes to the last commit
alias gcaa="git commit -a --amend -C HEAD"

alias gcb='git copy-branch-name'
alias gcl='git clone'
alias gco='git checkout'
alias gcount='git shortlog -sn'
alias gexport='git archive --format zip --output'
alias gg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gl='git pull --prune'
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gm="git merge"
alias gmu='git fetch origin -v; git fetch upstream -v; git merge upstream/master'
# From http://blogs.atlassian.com/2014/10/advanced-git-aliases/
# Show commits since last pull
alias gnew="git log HEAD@{1}..HEAD@{0}"
alias gp="git push origin HEAD"
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias gsl="git shortlog -sn"
alias gus="git reset HEAD"

repos() {
  git api --flat /users/$1/repos | grep git_url
}

alias git-top-level='cd /Users/charlesponti/Developer/zentreefish'

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

# Deploy directory to Github gh-pages branch
github-pages-deploy() {
  git subtree push --prefix "$@" origin gh-pages
}


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
