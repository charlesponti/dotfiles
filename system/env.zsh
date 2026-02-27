typeset -ga CORE_PATH_PARTS
CORE_PATH_PARTS=(
  "$HOME/.local/share/mise/shims"
  "$HOME/.dotfiles/bin"
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "/usr/local/bin"
  "/usr/local/sbin"
  "/usr/local/opt/python@3.12/libexec/bin"
  "/usr/local/opt/postgresql@15/bin"
  "$HOME/.cargo/bin"
  "$HOME/go/bin"
  "$HOME/.local/bin"
  "$HOME/.bun/bin"
  "$HOME/.cache/lm-studio/bin"
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
for candidate in "${CORE_PATH_PARTS[@]}"; do
  [[ -d "$candidate" ]] && path+=("$candidate")
done
if [[ -n "${PATH:-}" ]]; then
  _existing_path=("${(@s/:/)PATH}")
  for candidate in "${_existing_path[@]}"; do
    [[ -d "$candidate" ]] && path+=("$candidate")
  done
fi
export PATH
unset _existing_path candidate

export CORE_PATH_BASE="$(IFS=:; echo "${CORE_PATH_PARTS[*]}")"
export ADVANCED_LANE_ACTIVE=false
export NIX_CONFIG="extra-experimental-features = nix-command flakes"
export EDITOR="code"
export VISUAL="code"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
