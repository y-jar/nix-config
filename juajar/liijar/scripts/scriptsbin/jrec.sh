#!/usr/bin/env bash
set -eu

# jrec: wayland screen recording toggle (wf-recorder).
# Usage:
#   jrec            # toggle: start a region recording, or stop if running
#   jrec region     # start a slurp region recording
#   jrec screen     # start a full-screen recording
#   jrec stop       # stop any running recording
# Env:
#   JREC_DIR  output directory (default: ~/vidjar)
#   JREC_MIC=1 also capture the default microphone

OUT_DIR="${JREC_DIR:-$HOME/vidjar}"
PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/jrec.pid"
TS="$(date +'%Y-%m-%d_%H-%M-%S')"

running() {
  [ -f "$PIDFILE" ] || return 1
  local pid
  pid="$(cat "$PIDFILE" 2>/dev/null || true)"
  [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null
}

stop() {
  if running; then
    kill -INT "$(cat "$PIDFILE")" 2>/dev/null || true
    rm -f "$PIDFILE"
    notify-send "Recording" "Stopped -> $OUT_DIR" -i media-record 2>/dev/null || true
  else
    rm -f "$PIDFILE"
    notify-send "Recording" "Nothing to stop" -i media-record 2>/dev/null || true
  fi
}

start() {
  local mode="${1:-region}"
  local -a args=()
  mkdir -p "$OUT_DIR"
  local out="$OUT_DIR/rec_${TS}.mkv"

  case "$mode" in
    region)
      local geo
      geo="$(slurp -b '#00000000' -c '#d3866d')" || exit 1
      args=(-g "$geo")
      ;;
    screen) : ;;
    *)
      echo "jrec: unknown mode '$mode'" >&2
      exit 1
      ;;
  esac

  local -a cmd=(wf-recorder -f "$out" "${args[@]}")
  if [ "${JREC_MIC:-0}" = "1" ]; then
    cmd+=(--audio="$(pactl get-default-source)")
  fi

  "${cmd[@]}" >/dev/null 2>&1 &
  echo $! >"$PIDFILE"
  notify-send "Recording ($mode)" "-> $out" -i media-record 2>/dev/null || true
}

case "${1:-toggle}" in
  toggle)
    if running; then stop; else start region; fi
    ;;
  region | screen) start "$1" ;;
  stop) stop ;;
  -h | --help) sed -n '3,12p' "$0" ;;
  *)
    echo "usage: jrec [toggle|region|screen|stop]" >&2
    exit 1
    ;;
esac
