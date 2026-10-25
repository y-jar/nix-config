#!/usr/bin/env bash
set -eu

# sort-files: sort a directory's top-level files into category subfolders.
# Usage:
#   sort-files [-d] [dir]   (default dir: ~/Downloads)
#   -d, --dry-run  preview planned moves as mv lines, change nothing
# Env:
#   SORT_FILES_DIR  default dir when none is passed (default: ~/Downloads)

GRN=$'\033[0;32m'
CYN=$'\033[0;36m'
YLW=$'\033[0;33m'
RED=$'\033[0;31m'
BLD=$'\033[1m'
RST=$'\033[0m'

bucket_for() {
  local ext="$1"
  case "$ext" in
    jpg | jpeg | png | gif | webp | svg | bmp | heic)
      echo Images
      ;;
    pdf)
      echo PDFs
      ;;
    zip | tar | tar.gz | tgz | 7z | rar | xz | gz)
      echo Archives
      ;;
    py | sh | js | ts | json | c | cpp | h | rs | go | nix | html | css)
      echo Code
      ;;
    mp4 | mkv | webm | mov | avi)
      echo Videos
      ;;
    mp3 | flac | wav | ogg | m4a | opus)
      echo Audio
      ;;
    doc | docx | odt | md | txt | rtf | ods)
      echo Docs
      ;;
    *)
      echo ""
      ;;
  esac
}

usage() {
  cat <<'EOF'
sort-files: sort a directory's top-level files into category subfolders.

Usage: sort-files [-d] [dir]
  -d, --dry-run  preview planned moves as mv lines, change nothing
  (no dir)       defaults to ~/Downloads
EOF
}

dry=0
dir=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    -d | --dry-run) dry=1 ;;
    -h | --help)
      usage
      exit 0
      ;;
    -*)
      echo "sort-files: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      if [ -n "$dir" ]; then
        echo "sort-files: only one directory expected" >&2
        exit 2
      fi
      dir="$1"
      ;;
  esac
  shift
done
dir="${dir:-${SORT_FILES_DIR:-$HOME/Downloads}}"

if [ ! -d "$dir" ]; then
  printf '%snot a directory: %s%s\n' "$RED" "$dir" "$RST" >&2
  exit 1
fi

shopt -s nullglob

if [ "$dry" -eq 1 ]; then
  printf '%s[dry run] %sno changes will be made in %s%s\n' "$BLD" "$RST" "$dir" "$RST"
fi

moved=0
for f in "$dir"/*; do
  name="${f##*/}"
  [ -f "$f" ] || continue
  case "$name" in
    *.*) ;;
    *) continue ;;
  esac
  ext="${name##*.}"
  ext="${ext,,}"
  bucket="$(bucket_for "$ext")"
  [ -n "$bucket" ] || continue
  if [ -e "$dir/$bucket/$name" ]; then
    printf '%swarning: %s/%s exists, skipping%s\n' "$YLW" "$bucket" "$name" "$RST" >&2
    continue
  fi
  if [ "$dry" -eq 1 ]; then
    printf "mv '%s' -> '%s/%s/'\n" "$name" "$dir" "$bucket"
  else
    mkdir -p "$dir/$bucket"
    mv "$f" "$dir/$bucket/"
    printf '%smoved%s %s -> %s%s\n' "$GRN" "$CYN" "$name" "$bucket/" "$RST"
  fi
  moved=$((moved + 1))
done

if [ "$moved" -eq 0 ]; then
  printf '%snothing to sort in %s%s\n' "$YLW" "$dir" "$RST"
elif [ "$dry" -eq 1 ]; then
  printf '%s%d file(s) would be sorted in %s%s\n' "$BLD" "$moved" "$dir" "$RST"
else
  printf '%s%d file(s) sorted in %s%s\n' "$BLD" "$moved" "$dir" "$RST"
fi
