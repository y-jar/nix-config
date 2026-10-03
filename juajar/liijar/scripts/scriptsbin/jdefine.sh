#!/usr/bin/env bash
set -eu

# jdefine: look up a word definition and show it as a notification.
# Usage: jdefine [word]     (no arg: primary selection, then fuzzel prompt)

NOTIFY() { notify-send -t 60000 "jdefine" "$1" 2>/dev/null || true; }

word="${1:-}"
if [ -z "$word" ]; then
  word="$(wl-paste --primary --no-newline 2>/dev/null || true)"
fi
if [ -z "$word" ]; then
  word="$(printf '' | fuzzel --dmenu --prompt='Define > ' --lines=0)" || exit 0
fi
word="$(printf '%s' "$word" | tr -d '\n' | xargs)"
[ -n "$word" ] || exit 0
case "$word" in
  */*)
    NOTIFY "invalid input: $word"
    exit 0
    ;;
esac

query="$(curl -s --connect-timeout 5 --max-time 10 "https://api.dictionaryapi.dev/api/v2/entries/en/${word}")" || {
  NOTIFY "connection error"
  exit 1
}
case "$query" in
  *"No Definitions Found"*)
    NOTIFY "no definition for '$word'"
    exit 0
    ;;
esac

def="$(printf '%s' "$query" | jq -r '[.[].meanings[] | {pos: .partOfSpeech, def: .definitions[].definition}] | .[:3].[] | "\n\(.pos). \(.def)"')"
[ -n "$def" ] || {
  NOTIFY "no definition for '$word'"
  exit 0
}
notify-send -t 60000 "$word" "$def" 2>/dev/null || true
