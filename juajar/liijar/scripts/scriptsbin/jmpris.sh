#!/usr/bin/env bash
set -eu

# jmpris: pick an active MPRIS player with fuzzel and play/pause it.
# Usage:
#   jmpris                   # pick a player, toggle its play state
#   jmpris next|prev|toggle|stop

if [ "$#" -gt 0 ]; then
  case "$1" in
    next) playerctl next ;;
    prev) playerctl previous ;;
    toggle) playerctl play-pause ;;
    stop) playerctl stop ;;
    *)
      echo "usage: jmpris [next|prev|toggle|stop]" >&2
      exit 1
      ;;
  esac
  exit 0
fi

players="$(playerctl -l 2>/dev/null || true)"
[ -n "$players" ] || {
  notify-send "MPRIS" "no active players" 2>/dev/null || true
  exit 0
}

sel="$(printf '%s\n' "$players" | fuzzel --dmenu --prompt='Player > ' --lines=5)" || exit 0
[ -n "$sel" ] || exit 0

status="$(playerctl --player="$sel" status 2>/dev/null || echo Stopped)"
if [ "$status" = "Playing" ]; then
  action=play-pause
else
  action=play
fi
playerctl --player="$sel" "$action"

meta="$(playerctl --player="$sel" metadata --format '{{ artist }} - {{ title }}' 2>/dev/null || true)"
notify-send "MPRIS" "$sel: $meta" 2>/dev/null || true
