#!/usr/bin/env bash
set -eu

# jmv: batch rename files to <name><n>.<ext> (interactive overwrite prompts).
# Usage: jmv <file...>   (prompts for the base name; empty = timestamp)

[ "$#" -gt 0 ] || {
  echo "usage: jmv <file...>" >&2
  exit 1
}

read -rp "rename: " name || exit 0
name="${name:-$(date +'%a__%b%d__%H_%M_%S_')}"

i=1
for f in "$@"; do
  dir="${f%/*}"
  [ "$f" = "$dir" ] && dir=""
  base="${f##*/}"
  ext=""
  [ "$f" != "${f%.*}" ] && ext=".${f##*.}"
  new="${dir:+$dir/}${name}${i}${ext}"
  mv -i "$f" "$new" && notify-send "jmv" "'$base' -> '$new'" 2>/dev/null || true
  i=$((i + 1))
done
