#!/usr/bin/env bash
# web-search.sh
# Usage: wsearch

QUERY=$(echo "" | fuzzel --dmenu --lines=0 --prompt="Web > ")

[ -z "$QUERY" ] && exit 0

ENCODED=$(printf '%s' "$QUERY" | jq -sRr @uri)

xdg-open "https://duckduckgo.com/?q=$ENCODED"
