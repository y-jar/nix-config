#!/usr/bin/env bash
# jlayout — toggle the focused tag's layout between scroller <-> vertical_scroller.
# Uses mango IPC (mmsg); must run inside the mango session (env inherited from `spawn`).
# Bind: SUPER+CTRL+Slash  (SUPER+Slash sets scroller directly)
set -eu

if ! command -v mmsg >/dev/null 2>&1; then
  echo "jlayout: mmsg not found — are you in a mango session?" >&2
  exit 1
fi

mon="$(mmsg get cursorpos 2>/dev/null | jq -r '.monitor // empty')"
[ -n "$mon" ] || mon="$(mmsg get all-monitors 2>/dev/null | jq -r '.[0].name // empty')"
[ -n "$mon" ] || { echo "jlayout: could not determine monitor" >&2; exit 1; }

# layout symbol of the first active tag on the cursor monitor (layout = tag-rule symbol, e.g. S/VS)
sym="$(mmsg get tags "$mon" 2>/dev/null | jq -r '[.tags[] | select(.is_active == true)][0].layout // empty')"
[ -n "$sym" ] || sym="$(mmsg get all-tags 2>/dev/null | jq -r --arg mon "$mon" '[.all_tags[] | select(.monitor == $mon or .monitor.name == $mon) | .tags[] | select(.is_active == true)][0].layout // empty')"

# map symbol -> layout name (get layouts wraps in {layouts:[...]})
name="$(mmsg get layouts 2>/dev/null | jq -r --arg s "$sym" '[.layouts[] | select(.symbol == $s)][0].name // empty' | head -n1)"
[ -n "$name" ] || name=scroller

if [ "$name" = "vertical_scroller" ]; then
  target=scroller
else
  target=vertical_scroller
fi

mmsg dispatch setlayout,"$target"