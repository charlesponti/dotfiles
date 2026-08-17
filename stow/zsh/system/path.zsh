# Builds PATH with mise's shims first so mise-managed tool versions
# (node, pnpm, etc.) always resolve ahead of Homebrew and other
# system installs. Sourced from .zshenv so this applies to every zsh
# invocation -- login, interactive, or not -- including the
# non-interactive shells that GUI apps (VS Code, Docker Desktop,
# Finder-launched apps) and editors use to resolve PATH, which never
# source .zshrc.
typeset -ga PATH_PARTS
PATH_PARTS=(
  "$HOME/.local/share/mise/shims"
  "$HOME/.dotfiles/stow/bin/bin"
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "/usr/local/bin"
  "/usr/local/sbin"
  "/opt/homebrew/opt/postgresql@18/bin"
  "$HOME/.cargo/bin"
  "$HOME/go/bin"
  "$HOME/.local/bin"
  "$HOME/.bun/bin"
  "$HOME/.nix-profile/bin"
  "/nix/var/nix/profiles/default/bin"
  "$HOME/bin"
  "/usr/bin"
  "/usr/sbin"
  "/bin"
  "/sbin"
  "$HOME/Developer/scripts"
)

typeset -Ua path
typeset -a _existing_path
path=()
for candidate in "${PATH_PARTS[@]}"; do
  [[ -d "$candidate" ]] && path+=("$candidate")
done
if [[ -n "${PATH:-}" ]]; then
  _existing_path=("${(@s/:/)PATH}")
  for candidate in "${_existing_path[@]}"; do
    [[ -d "$candidate" ]] && path+=("$candidate")
  done
fi

export PATH="${(j/:/)path}"
unset _existing_path candidate
