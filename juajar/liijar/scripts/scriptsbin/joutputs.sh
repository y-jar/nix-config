#!/usr/bin/env bash
# joutputs: list connected DRM outputs and print paste-ready Nix blocks for
# configuring usrset.tabletenable (see hstjar/tabletconf.nix).
#
# Usage: joutputs [options] [connector|all]
#   (none)          list connected outputs
#   <connector>     list + Nix blocks for that connector (e.g. DP-2)
#   all             list + Nix blocks for every connected output
# Options:
#   -r, --refresh   also show refresh-rate options (per preferred resolution)
#   -c, --copy      also copy the emitted blocks to the clipboard (wl-copy)
#   -h, --help      this help
#
# Env (injected by the nix loader):
#   JOUTPUTS_DI_EDID_DECODE  path to di-edid-decode (libdisplay-info)
#   JOUTPUTS_WL_COPY         path to wl-copy (wl-clipboard)
#
# NOTE: we emit model:/serial: (never make:) because mango/wlroots resolves the
# EDID manufacturer from its own hardcoded PNP table, which will not match the
# raw 3-letter code a decoder prints.
set -eu

DEC="${JOUTPUTS_DI_EDID_DECODE:-di-edid-decode}"
WLCOPY="${JOUTPUTS_WL_COPY:-wl-copy}"

usage() {
  cat <<'EOF'
joutputs: list connected DRM outputs and print paste-ready Nix blocks for
configuring usrset.tabletenable (see hstjar/tabletconf.nix).

Usage: joutputs [options] [connector|all]
  (none)          list connected outputs
  <connector>     list + Nix blocks for that connector (e.g. DP-2)
  all             list + Nix blocks for every connected output
Options:
  -r, --refresh   also show refresh-rate options (per preferred resolution)
  -c, --copy      also copy the emitted blocks to the clipboard (wl-copy)
  -h, --help      this help
EOF
}

copy=0
refresh=0
target=""
for a in "$@"; do
  case "$a" in
    -c | --copy) copy=1 ;;
    -r | --refresh) refresh=1 ;;
    -h | --help)
      usage
      exit 0
      ;;
    -*)
      echo "joutputs: unknown option: $a" >&2
      exit 2
      ;;
    *) target="$a" ;;
  esac
done

# refresh rates offered at a given resolution, from the EDID timing descriptors
refresh_opts() { # <edid> <WxH>
  local edid="$1" mode="$2" w h
  [ -n "$mode" ] || return 0
  w="${mode%x*}"
  h="${mode#*x}"
  [ "${mode#*x}" != "$mode" ] || return 0
  "$DEC" "$edid" 2>/dev/null |
    grep -vE 'Monitor ranges' |
    grep -E "[[:space:]]${w}x${h}[[:space:]]" |
    grep -oE '[0-9]+(\.[0-9]+)? Hz' |
    awk '{ printf "%.2f\n", $1 }' |
    sort -nu |
    paste -sd, - |
    sed 's/,/, /g'
}

# ---- collect connected outputs into "conn|model|serial|mode|refresh" ----
conns=()
for d in /sys/class/drm/card*-*; do
  [ -r "$d/status" ] || continue
  [ "$(cat "$d/status" 2>/dev/null || true)" = connected ] || continue
  conn="${d##*/}"
  conn="${conn#card*-}"
  model=""
  serial=""
  edid="$d/edid"
  if [ -r "$edid" ] && [ -n "$DEC" ]; then
    out="$("$DEC" "$edid" 2>/dev/null || true)"
    if [ -n "$out" ]; then
      model="$(printf '%s\n' "$out" | sed -n "s/.*Display Product Name: '\(.*\)'.*/\1/p" | head -n1)"
      serial="$(printf '%s\n' "$out" | sed -n "s/.*Display Product Serial Number: '\(.*\)'.*/\1/p" | head -n1)"
    fi
    # fallback: wlroots-style 0x%04X of the EDID product code (bytes 10-11 LE)
    if [ -z "$model" ]; then
      lo="$(od -An -tu1 -j10 -N1 "$edid" 2>/dev/null | tr -d ' ')"
      hi="$(od -An -tu1 -j11 -N1 "$edid" 2>/dev/null | tr -d ' ')"
      if [ -n "$lo" ] && [ -n "$hi" ]; then
        model="$(printf '0x%04X' "$((lo + 256 * hi))")"
      fi
    fi
  fi
  [ -n "$model" ] || model="<unknown>"
  mode="$(head -n1 "$d/modes" 2>/dev/null || true)"
  refr=""
  if [ "$refresh" -eq 1 ] && [ -r "$edid" ]; then
    refr="$(refresh_opts "$edid" "$mode" || true)"
  fi
  conns+=("${conn}|${model}|${serial}|${mode}|${refr}")
done

if [ "${#conns[@]}" -eq 0 ]; then
  echo "joutputs: no connected DRM outputs found" >&2
  exit 1
fi

# ---- table ----
printf '%-12s %-22s %-16s %s\n' CONNECTOR MODEL SERIAL PREFERRED
for row in "${conns[@]}"; do
  IFS='|' read -r c m s p _ <<<"$row"
  printf '%-12s %-22s %-16s %s\n' "$c" "$m" "${s:--}" "${p:--}"
done

# ---- refresh-rate options ----
if [ "$refresh" -eq 1 ]; then
  printf '\nREFRESH RATE OPTIONS (at each output'"'"'s preferred resolution)\n'
  for row in "${conns[@]}"; do
    IFS='|' read -r c _ _ p r <<<"$row"
    printf '  %-12s %-12s %s Hz\n' "$c" "${p:--}" "${r:-unknown}"
  done
fi

# ---- current geometry from mango IPC, when available (x y scale) ----
read_geom() {
  command -v mmsg >/dev/null 2>&1 || return 0
  command -v jq >/dev/null 2>&1 || return 0
  mmsg get all-monitors 2>/dev/null |
    jq -r --arg n "$1" '.monitors[] | select(.name==$n) | "\(.x) \(.y) \(.scale)"' 2>/dev/null |
    head -n1
}

emit_block() {
  local conn="$1" model="$2" serial="$3" mode="$4" refr="$5"
  local w="" h=""
  if [ "${mode#*x}" != "$mode" ] && [ -n "$mode" ]; then
    w="${mode%x*}"
    h="${mode#*x}"
  fi
  local x=0 y=0 scale=1 g=""
  g="$(read_geom "$conn" || true)"
  if [ -n "$g" ]; then
    x="${g%% *}"
    local rest="${g#* }"
    y="${rest%% *}"
    scale="${rest#* }"
  fi
  cat <<EOF
# --- hstjar/tabletconf.nix  (rename the key to your device) ---
  mytablet = {
    # ${conn}  ${model}  ${serial:-no serial}
    match = "model:${model}";
EOF
  if [ -n "$serial" ] && ! printf '%s' "$serial" | grep -qE '^0+$'; then
    cat <<EOF
    # fallback if the product name changes: match = "serial:${serial}";
EOF
  fi
  cat <<EOF
  };

# --- hstjar/<host>/user.nix ---
    tabletenable.mytablet.enable = true;

# --- optional: wmconfigs/mango/host-inputs/<host>.conf  (adjust geometry) ---
EOF
  [ -n "$refr" ] && printf '# refresh options: %s Hz\n' "$refr"
  cat <<EOF
monitorrule=model:${model},width:${w:-W},height:${h:-H},x:${x},y:${y},scale:${scale}
EOF
}

# ---- assemble blocks for the requested target ----
blocks=""
case "$target" in
  "")
    : # table only
    ;;
  all)
    for row in "${conns[@]}"; do
      IFS='|' read -r c m s p r <<<"$row"
      blocks="${blocks}$(emit_block "$c" "$m" "$s" "$p" "$r")
"
    done
    ;;
  *)
    found=0
    for row in "${conns[@]}"; do
      IFS='|' read -r c m s p r <<<"$row"
      if [ "$c" = "$target" ]; then
        blocks="$(emit_block "$c" "$m" "$s" "$p" "$r")"
        found=1
        break
      fi
    done
    if [ "$found" -eq 0 ]; then
      echo "joutputs: no connected output named '$target'" >&2
      printf 'connected: %s\n' "$(printf '%s ' "${conns[@]%%|*}")" >&2
      exit 1
    fi
    ;;
esac

if [ -n "$blocks" ]; then
  printf '\n%s' "$blocks"
  if [ "$copy" -eq 1 ]; then
    if printf '%s' "$blocks" | "$WLCOPY" 2>/dev/null; then
      printf '\n# (blocks copied to clipboard)\n' >&2
    else
      echo "joutputs: clipboard copy failed (is a Wayland session running?)" >&2
    fi
  fi
else
  printf '\n# run: joutputs <connector>   for paste-ready Nix blocks\n'
fi
