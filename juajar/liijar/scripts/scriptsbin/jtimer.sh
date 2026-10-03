#!/usr/bin/env bash
set -eu

# jtimer: quick countdown timer (fuzzel + notification).
# Usage:
#   jtimer [minutes]   (no arg: prompt)
#   jtimer cancel

PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/jtimer.pid"

cancel() {
  if [ -f "$PIDFILE" ]; then
    kill "$(cat "$PIDFILE")" 2>/dev/null || true
    rm -f "$PIDFILE"
    notify-send "Timer" "Cancelled" 2>/dev/null || true
  fi
}

if [ "${1:-}" = "cancel" ]; then
  cancel
  exit 0
fi

minutes="${1:-$(printf '' | fuzzel --dmenu --prompt='Minutes > ' --lines=0)}"
[ -n "$minutes" ] || exit 0
case "$minutes" in
  '' | *[!0-9]*)
    notify-send "Timer" "Invalid minutes: $minutes" 2>/dev/null || true
    exit 1
    ;;
esac

cancel
(
  sleep "$((minutes * 60))"
  notify-send -u critical "Timer" "${minutes} minute(s) are up!" 2>/dev/null || true
  rm -f "$PIDFILE"
) &
echo $! >"$PIDFILE"
notify-send "Timer" "Started ${minutes}m" 2>/dev/null || true
