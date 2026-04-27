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

# the original code mistakenly exported an empty PATH and then
# replaced it with CORE_PATH_BASE, effectively discarding the
# computed list; use the assembled variable instead
export PATH="${(j/:/)path}"
unset _existing_path candidate

export NIX_CONFIG="extra-experimental-features = nix-command flakes"
export EDITOR="code"
export VISUAL="code"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
