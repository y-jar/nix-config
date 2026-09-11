#!/usr/bin/env bash
# jbinds mango keybind cheat sheet in a floating foot window.
# Parses ~/.config/mango/binds.conf into a sectioned "key -> action" table.
# Bind: SUPER+SHIFT+Slash ("?"). Close: press any key (or q) inside the window.
set -eu

binds="${JBINDS_BINDS:-$HOME/.config/mango/binds.conf}"

if [ ! -f "$binds" ]; then
  echo "jbinds: no binds file at $binds" >&2
  exit 1
fi

table="$(awk '
  function header(h) {
    sub(/^[ \t]*#[ \t]*/, "", h)          # drop "#" and following space
    gsub(/^[ \t]*[=+\-]+/, "", h)         # drop leading dashes/equals
    sub(/[ \t]*[=+\-]+[ \t]*$/, "", h)    # drop trailing dashes/equals
    sub(/[ \t]+$/, "", h)                 # drop trailing spaces
    if (h != "") printf "\n\033[1;36m%s\033[0m\n", h
  }
  /^[ \t]*#[ \t]*[=+\-]+/ { header($0); next }
  /^[ \t]*#/ { next }
  /^[ \t]*$/ { last=0; next }
  /^[ \t]*(bind|mousebind|axisbind|gesturebind)/ {
    sub(/[ \t]+#.*$/, "")                 # drop trailing inline comments
    eq = index($0, "=")
    if (eq == 0) next
    lhs = substr($0, 1, eq - 1)
    rhs = substr($0, eq + 1)
    n = split(rhs, f, ",")
    if (n < 3) next
    printf "  \033[1;33m%-26s\033[0m %s\n", f[1] "+" f[2], f[3] (n >= 4 ? "," f[4] : "") (n >= 5 ? "," f[5] : "")
    next
  }
' "$binds")"
[ -n "$table" ] || table="no binds found in $binds"

export JBINDS_TABLE="$table"
exec foot --app-id=jbinds -T keybinds bash -c 'printf "%s\n" "$JBINDS_TABLE"; echo; printf "  \e[2m[ press any key to close ]\e[0m\n"; read -r -n1 _'
