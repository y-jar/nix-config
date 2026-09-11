#!/usr/bin/env bash
set -eu

WALL_DIR="$HOME/resjar/wall-jar/wall-bin"
[[ -d "$WALL_DIR" ]] || WALL_DIR="$HOME/resjar/wall-jar"

if [[ ! -d "$WALL_DIR" ]]; then
    echo "No wallpaper directory found at $HOME/resjar/wall-jar/" >&2
    exit 1
fi

WALL=$(find "$WALL_DIR" -type f 2>/dev/null | sort \
    | fzf --prompt="Wallpaper > " \
          --preview="chafa --symbols solid --size 80x40 {}" \
          --height=80% \
          --reverse)

if [[ -z "$WALL" ]]; then
    exit 0
fi

awww img "$WALL"
mkdir -p "$HOME/.cache/shelljar"
printf '%s\n' "$WALL" > "$HOME/.cache/shelljar/current-wall"
