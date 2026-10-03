#!/usr/bin/env bash
set -eu

# jnote: quick note capture (fuzzel). New note or open a recent one.
# Usage: jnote
# Env:
#   JNOTE_DIR     notes directory (default: ~/docjar/notes-jar)
#   JNOTE_EDITOR  editor command (default: foot -e nvim)

NOTES_DIR="${JNOTE_DIR:-$HOME/docjar/notes-jar}"
EDITOR_CMD="${JNOTE_EDITOR:-foot -e nvim}"

mkdir -p "$NOTES_DIR"

new_note() {
  local name file
  name="$(printf '' | fuzzel --dmenu --prompt='Note name (empty = timestamp) > ' --lines=0)" || exit 0
  [ -n "$name" ] || name="$(date +'%F_%H-%M-%S')"
  file="$NOTES_DIR/${name%.md}.md"
  [ -e "$file" ] || printf '# %s\n\n' "${name%.md}" >"$file"
  # shellcheck disable=SC2086
  $EDITOR_CMD "$file"
}

choice="$(printf 'New\n%s\n' \
  "$(find "$NOTES_DIR" -maxdepth 1 -type f -name '*.md' -printf '%T@ %f\n' 2>/dev/null | sort -rn | cut -d' ' -f2-)" \
  | fuzzel --dmenu --prompt='Note > ' --lines=10)" || exit 0
[ -n "$choice" ] || exit 0

if [ "$choice" = "New" ]; then
  new_note
else
  # shellcheck disable=SC2086
  $EDITOR_CMD "$NOTES_DIR/$choice"
fi
