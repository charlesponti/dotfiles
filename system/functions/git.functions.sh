#!/usr/bin/env bash

#-----------------------
# Git
#-----------------------

#######################################
# Initialize a Git repository
# Globals:
#   HOME
# Arguments:
#   None
# Returns:
#   None
#######################################
function git-init() {
  # Initialize repository
  git init
  # Copy .gitignore
  cp $HOME/.dotfiles/home/.gitignore_global .gitignore
}

function gdiff {
  git --no-pager diff --color=auto --no-ext-diff --no-index "$@"
}

# Replace the author and email of old commits. Very handy when updating someone's name and/or email.
# $1 - Original Author Name which will be replaced
# $2 - Name to replace original name with
# $3 - Email to replace original email with
function git-rename-author() {
  git filter-branch --env-filter "if [ '$GIT_AUTHOR_NAME' = $1 ]; then
     GIT_AUTHOR_EMAIL=$2;
     GIT_AUTHOR_NAME=$1;
     GIT_COMMITTER_EMAIL=$2;
     GIT_COMMITTER_NAME=$1; fi" -f -- --all
}

# Deploy directory to Github gh-pages branch
function github-pages-deploy() {
  git subtree push --prefix "$@" origin gh-pages
}
