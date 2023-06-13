#!/usr/bin/env bash

dotfiles=~/.dotfiles
source $dotfiles/bin/printf.sh

set -e

echo ''


link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

SCRIPTS=$dotfiles/bin

informer "😲 Installing Homebrew"
bash $SCRIPTS/installers/homebrew-install.sh
success "Done!"

informer "😲 Installing Git"
bash $SCRIPTS/installers/git-install.sh
success "Done!"

informer "😲 Installing Python"
bash $SCRIPTS/installers/python-install.sh
success "Done!"

informer "😲 Installing NodeJS"
bash $SCRIPTS/installers/nodejs-install.sh
success "Done!"

informer "😲 Configuring MacOS"
bash $SCRIPTS/macos/base.sh
success "Done!"

informer "😲 Installing applications..."
sh -c $SCRIPTS/applications.sh
success ' Done!'

informer "📁 Making ~/Developer folder"
mkdir ~/Developer

informer "😲 Installing dotfiles"
bash $SCRIPTS/symlinks.sh
success "Done!"

success "🚀 Ready to ROCK! 🚀"
