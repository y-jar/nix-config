#!/usr/bin/env bash
# jshot wayland screenshot tool (grim + slurp + swappy)
# Usage: jshot [region|screen|window]
# Saves to ~/picjar/shotbin with a date/timestamp filename (matches niri's path).
set -eu

SHOT_DIR="$HOME/picjar/shotbin"
mkdir -p "$SHOT_DIR"
TS="$(date +'%Y-%m-%d_%H-%M-%S')"
OUT="$SHOT_DIR/shot_${TS}.png"

mode="${1:-region}"

case "$mode" in
  region)
    grim -g "$(slurp -b '#1e1e2e80' -c '#5F7CB8')" "$OUT"
    ;;
  screen)
    grim "$OUT"
    ;;
  window)
    # geometry of the focused window via mango IPC (fallback: full screen).
    # uses `jq` to build a grim "x,y WxH" string (same WxH as screen on failure).
    geo="$(mmsg get focusing-client 2>/dev/null \
      | jq -r '"\(.x),\(.y) \(.width)x\(.height)"' 2>/dev/null || true)"
    if [[ -n "$geo" && "$geo" != "null" ]]; then
      grim -g "$geo" "$OUT"
    else
      grim "$OUT"
    fi
    ;;
  *)
    echo "usage: jshot [region|screen|window]" >&2
    exit 1
    ;;
esac

# open in swappy for editing if it exists
if command -v swappy >/dev/null 2>&1; then
  swappy -f "$OUT"
fi

notify-send "Screenshot" "Saved to $OUT" -i camera-photo 2>/dev/null || true
