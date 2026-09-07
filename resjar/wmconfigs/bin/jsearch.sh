#!/usr/bin/env bash
# web-search.sh
# Usage: jsearch

QUERY=$(echo "" | fuzzel --dmenu --lines=0 --prompt="Web > ")

[ -z "$QUERY" ] && exit 0

if echo "$QUERY" | grep -qi "webjar"; then
    xdg-open "http://$(hostname)"
    exit 0
fi

ENCODED=$(printf '%s' "$QUERY" | jq -sRr @uri)

xdg-open "https://duckduckgo.com/?q=$ENCODED"
