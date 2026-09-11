#!/usr/bin/env bash
# jclip — clipboard history menu (cliphist + fuzzel)
# Usage:
#   jclip            # pick an entry and put it on the clipboard
#   jclip --wipe     # clear clipboard history
# jclip relies on a running cliphist store ('wl-paste --watch cliphist store').
set -eu

mode="${1:-pick}"

case "$mode" in
  pick)
    entry="$(cliphist list | fuzzel --dmenu --prompt='Clipboard > ')"
    if [[ -z "$entry" ]]; then
      exit 0
    fi
    # cliphist decode restores the original bytes (text or image).
    printf '%s\n' "$entry" | cliphist decode | wl-copy
    notify-send "Clipboard" "Copied entry" -i edit-paste 2>/dev/null || true
    ;;
  wipe)
    cliphist wipe
    notify-send "Clipboard" "History cleared" -i edit-clear 2>/dev/null || true
    ;;
  *)
    echo "usage: jclip [pick|--wipe]" >&2
    exit 1
    ;;
esac