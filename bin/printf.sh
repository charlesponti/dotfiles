informer () {
  printf "\n[ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\n[ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\n\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\n\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  exit
}
