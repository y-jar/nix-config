#!/usr/bin/env bash
set -eu

# jnight: toggle a warm (night) color filter (gammastep) + screen dimming.
# Usage: jnight [on|off|toggle|dim+|dim-]
# Env: JNIGHT_TEMP  color temperature in K (default: 4000)

PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/jnight.pid"
TEMP="${JNIGHT_TEMP:-4000}"

running() {
  [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null
}

on() {
  if running; then return 0; fi
  gammastep -O "$TEMP" >/dev/null 2>&1 &
  echo $! >"$PIDFILE"
  notify-send "Night light" "on (${TEMP}K)" 2>/dev/null || true
}

off() {
  if running; then kill "$(cat "$PIDFILE")" 2>/dev/null || true; fi
  pkill -x gammastep 2>/dev/null || true
  rm -f "$PIDFILE"
  notify-send "Night light" "off" 2>/dev/null || true
}

case "${1:-toggle}" in
  on) on ;;
  off) off ;;
  toggle)
    if running; then off; else on; fi
    ;;
  dim+) brightnessctl --class=backlight set 5%- 2>/dev/null || true ;;
  dim-) brightnessctl --class=backlight set +5% 2>/dev/null || true ;;
  *)
    echo "usage: jnight [on|off|toggle|dim+|dim-]" >&2
    exit 1
    ;;
esac
