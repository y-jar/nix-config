#!/usr/bin/env bash
set -eu

WALL_DIR="$HOME/resjar/wall-jar/wall-bin"
[[ -d "$WALL_DIR" ]] || WALL_DIR="$HOME/resjar/wall-jar"
WALL_DIR="${WALL_DIR}/"

WALL=$(find "$WALL_DIR" -type f 2>/dev/null | shuf -n1)
if [[ -z "$WALL" ]]; then
    echo "No wallpapers found in $WALL_DIR" >&2
    exit 1
fi

awww img "$WALL" --transition-type fade --transition-duration 1
mkdir -p "$HOME/.cache/shelljar"
printf '%s\n' "$WALL" > "$HOME/.cache/shelljar/current-wall"
