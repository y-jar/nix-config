#!/usr/bin/env bash
set -eu

# jdefine: look up a word definition and show it as a notification.
# Usage: jdefine [word]     (no arg: fuzzel prompt; primary selection is offered
#                            as the default entry, but you can always type)
# Env:
#   JDEFINE_API  primary endpoint base (default: dictionaryapi.dev)

NOTIFY() { notify-send -t 60000 "jdefine" "$1" 2>/dev/null || true; }

word="${1:-}"
if [ -z "$word" ]; then
  # always prompt; offer the current primary selection as the default entry
  sel="$(timeout 0.5 wl-paste --primary --no-newline 2>/dev/null || true)"
  if [ -n "$sel" ]; then
    word="$(printf '%s\n' "$sel" | fuzzel --dmenu --prompt='Define > ' --lines=3)" || exit 0
  else
    word="$(printf '' | fuzzel --dmenu --prompt='Define > ' --lines=0)" || exit 0
  fi
fi
word="$(printf '%s' "$word" | tr -d '\n' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
[ -n "$word" ] || exit 0
case "$word" in
  */*)
    NOTIFY "invalid input: $word"
    exit 0
    ;;
esac

enc="$(printf '%s' "$word" | jq -sRr @uri)"

# =-=-=[primary: dictionaryapi.dev]
def="$(
  curl -fsS --connect-timeout 3 --max-time 4 \
    "${JDEFINE_API:-https://api.dictionaryapi.dev/api/v2/entries/en}/$enc" 2>/dev/null \
    | jq -r 'if type=="array" then [.[].meanings[] | {pos: .partOfSpeech, def: .definitions[].definition}] | .[:3].[] | "\(.pos). \(.def)" else empty end' 2>/dev/null || true
)"

# =-=-=[fallback: Wiktionary REST]
if [ -z "$def" ]; then
  def="$(
    curl -fsS --connect-timeout 4 --max-time 6 \
      "https://en.wiktionary.org/api/rest_v1/page/definition/$enc" 2>/dev/null \
      | jq -r '[(.en // [])[] as $e | $e.definitions[] | select((.definition // "") | test("\\S")) | {p: $e.partOfSpeech, d: (.definition | gsub("<[^>]*>"; ""))}] | .[:3][] | "\(.p). \(.d)"' 2>/dev/null || true
  )"
fi

[ -n "$def" ] || {
  NOTIFY "no definition for '$word'"
  exit 0
}
notify-send -t 60000 "$word" "$def" 2>/dev/null || true
