#!/usr/bin/env sh
set -eu

name="${1:-}"
template="${2:-power}"
root="${3:-$HOME/Developer}"

if [ -z "$name" ]; then
  echo "usage: workspace-new.sh <name> <core|power> [root]" >&2
  exit 1
fi

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux is required" >&2
  exit 1
fi

workdir="$root/$name"
mkdir -p "$workdir"

if tmux has-session -t "$name" 2>/dev/null; then
  tmux attach-session -t "$name"
  exit 0
fi

tmux new-session -d -s "$name" -c "$workdir" -n editor

case "$template" in
  core)
    tmux split-window -h -t "$name:editor" -c "$workdir"
    tmux select-layout -t "$name:editor" main-horizontal
    ;;
  power)
    tmux split-window -h -t "$name:editor" -c "$workdir"
    tmux select-layout -t "$name:editor" main-horizontal
    tmux new-window -t "$name" -n server -c "$workdir"
    tmux new-window -t "$name" -n logs -c "$workdir"
    ;;
  *)
    echo "invalid template: $template" >&2
    exit 1
    ;;
esac

tmux select-window -t "$name:editor"
tmux attach-session -t "$name"
