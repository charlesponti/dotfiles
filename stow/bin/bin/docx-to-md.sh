#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: docx-to-md.sh [options] [paths...]

Convert .docx files to Markdown with pandoc.
Works well directly, from Raycast, or from the Finder Quick Action.

Arguments:
  paths...            One or more .docx files and/or directories.
                      Directories are searched recursively.
                      Defaults to the current directory.

Options:
  -o, --overwrite     Replace existing .md outputs.
      --no-media      Do not extract embedded media.
  -h, --help          Show this help message.

Examples:
  docx-to-md
  docx-to-md notes.docx
  docx-to-md ~/Documents/research --overwrite
EOF
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

overwrite=false
extract_media=true
paths=()
docx_files=()

while (($#)); do
  case "$1" in
    -o|--overwrite)
      overwrite=true
      shift
      ;;
    --no-media)
      extract_media=false
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      paths+=("$@")
      break
      ;;
    -*)
      fail "Unknown option: $1"
      ;;
    *)
      paths+=("$1")
      shift
      ;;
  esac
done

if ! command -v pandoc >/dev/null 2>&1; then
  fail "pandoc is required. Install it with: brew install pandoc"
fi

if ((${#paths[@]} == 0)); then
  paths=(.)
fi

collect_docx() {
  local path="$1"
  local found=false

  if [[ -d "$path" ]]; then
    while IFS= read -r -d '' file; do
      docx_files+=("$file")
      found=true
    done < <(find "$path" -type f -iname '*.docx' -print0 | sort -z)
    return 0
  fi

  if [[ -e "$path" ]]; then
    while IFS= read -r -d '' file; do
      docx_files+=("$file")
      found=true
    done < <(find "$path" -maxdepth 0 -type f -iname '*.docx' -print0)

    if [[ "$found" == false ]]; then
      fail "Not a .docx file: $path"
    fi
    return 0
  fi

  fail "Path not found: $path"
}

for path in "${paths[@]}"; do
  collect_docx "$path"
done

if ((${#docx_files[@]} == 0)); then
  printf 'No .docx files found.\n'
  exit 0
fi

converted=0
skipped=0
failed=0

for file in "${docx_files[@]}"; do
  target_md="${file%.*}.md"
  media_dir="${file%.*}_media"

  if [[ -e "$target_md" && "$overwrite" != true ]]; then
    printf 'Skipped: %s (exists: %s)\n' "$file" "$target_md"
    skipped=$((skipped + 1))
    continue
  fi

  pandoc_args=("$file" -t gfm --wrap=none -o "$target_md")
  if [[ "$extract_media" == true ]]; then
    pandoc_args=("$file" -t gfm --wrap=none --extract-media="$media_dir" -o "$target_md")
  fi

  if pandoc "${pandoc_args[@]}"; then
    printf 'Converted: %s -> %s\n' "$file" "$target_md"
    converted=$((converted + 1))
  else
    printf 'Failed: %s\n' "$file" >&2
    failed=$((failed + 1))
  fi
done

printf '\nSummary: %d converted, %d skipped, %d failed\n' "$converted" "$skipped" "$failed"

if ((failed > 0)); then
  exit 1
fi
