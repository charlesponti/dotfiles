# make sure bytecode caches exist for our stowed modules. zsh will
# automatically load the .zwc file instead of reparsing the source when
# it's newer, so compiling them ahead of time speeds up startup.
zsh_compile_stowed_modules() {
  if (( ! ${+commands[zcompile]} )); then
    return 0
  fi

  for f in "$HOME/.dotfiles/stow/zsh/system"/*.zsh; do
    [[ -f "$f" ]] || continue
    [[ "$f" -nt "${f}c" ]] && zcompile "$f"
  done
}
