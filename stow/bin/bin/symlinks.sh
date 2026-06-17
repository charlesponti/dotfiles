#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$script_dir/lib.sh"
dotfiles_root="$(resolve_dotfiles_root "$script_dir")"
cd "$dotfiles_root"

packages=(ghostty zsh git tmux starship vim vscode zed raycast bin services)
stow_args=(-v -t "$HOME" -d stow --ignore='\.DS_Store')

usage() {
  cat <<'EOF'
Usage: symlinks.sh [--backup-conflicts|--adopt] [--] [packages...]

Stow dotfiles packages into $HOME.

Options:
  --backup-conflicts  Move existing non-symlink targets out of the way first.
  --adopt             Let stow adopt existing targets into the repo.

If packages are provided, only those packages are stowed.
EOF
}

backup_conflicts=false

while (($#)); do
  case "$1" in
    --backup-conflicts)
      backup_conflicts=true
      shift
      ;;
    --adopt)
      stow_args+=(--adopt)
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      break
      ;;
  esac
done

if (($#)); then
  packages=("$@")
fi

backup_target() {
  local source_path="$1"
  local relative_path="${source_path#stow/*/}"
  local target_path="$HOME/$relative_path"
  local ancestor="$HOME"
  local part
  local -a path_parts

  [[ -e "$target_path" || -L "$target_path" ]] || return 0
  [[ -L "$target_path" ]] && return 0

  IFS=/ read -r -a path_parts <<< "$relative_path"
  for part in "${path_parts[@]:0:${#path_parts[@]}-1}"; do
    ancestor="$ancestor/$part"
    [[ -L "$ancestor" ]] && return 0
  done

  local backup_path="$backup_root/$relative_path"

  mkdir -p "$(dirname "$backup_path")"
  mv "$target_path" "$backup_path"
  echo "BACKUP: $target_path => $backup_path"
}

if [[ "$backup_conflicts" == true ]]; then
  backup_root="$HOME/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)"
  package_paths=()
  for package in "${packages[@]}"; do
    package_paths+=("stow/$package")
  done

  while IFS= read -r -d '' file; do
    backup_target "$file"
  done < <(
    find "${package_paths[@]}" \
      -type f \
      ! -name '.DS_Store' \
      -print0
  )
fi

echo "Stowing packages..."
stow "${stow_args[@]}" "${packages[@]}"
