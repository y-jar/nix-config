#!/usr/bin/env bash
set -eu

# morning: small morning dashboard (greeting banner, weather, uptime,
# calendar, disk).
# Usage: morning
# Env:
#   MORNING_CURL  curl binary for the weather call (default: curl)
#   JWEATHER_LOC  wttr.in location query (default: '?format=3')

CURL="${MORNING_CURL:-curl}"

GRN=$'\033[0;32m'
CYN=$'\033[0;36m'
YLW=$'\033[0;33m'
RED=$'\033[0;31m'
BLD=$'\033[1m'
RST=$'\033[0m'
DIM=$'\033[0;90m'

hdr() {
  printf '\n%s%s-- %s --%s\n' "$BLD" "$CYN" "$1" "$RST"
}

hour=$((10#$(date +%H)))
if [ "$hour" -lt 5 ] || [ "$hour" -ge 22 ]; then
  greet="Rest well"
elif [ "$hour" -lt 12 ]; then
  greet="Good morning"
elif [ "$hour" -lt 18 ]; then
  greet="Good afternoon"
else
  greet="Good evening"
fi

printf '%s%s' "$BLD" "$CYN"
cat <<'EOF'
     _              __  __                  _
    | | __ _ _ __  |  \/  | ___  _ __ _ __ (_)_ __   __ _
 _  | |/ _` | '__| | |\/| |/ _ \| '__| '_ \| | '_ \ / _` |
| |_| | (_| | |    | |  | | (_) | |  | | | | | | | | (_| |
 \___/ \__,_|_|    |_|  |_|\___/|_|  |_| |_|_|_| |_|\__, |
                                                    |___/
EOF
printf '%s\n' "$RST"
printf '%s%s, %s%s!  %s%s%s\n' "$GRN" "$greet" "$BLD" "${USER:-$(id -un)}" "$YLW" "$(date +'%A, %d %B %Y')" "$RST"

hdr Weather
if weather="$("$CURL" -fsS --max-time 5 "https://wttr.in/${JWEATHER_LOC:-?format=3}" 2>/dev/null)" && [ -n "$weather" ]; then
  printf ' %s%s%s\n' "$YLW" "$weather" "$RST"
else
  printf ' %sweather unavailable (offline?)%s\n' "$DIM" "$RST"
fi

hdr Uptime
up_line="$(uptime -p 2>/dev/null || uptime 2>/dev/null || printf 'unknown')"
printf ' %s%s%s\n' "$GRN" "$up_line" "$RST"

hdr Calendar
if command -v calcurse >/dev/null 2>&1; then
  appts="$(calcurse -n 2>/dev/null || true)"
  if [ -n "$appts" ]; then
    printf '%s' "$GRN"
    printf '%s\n' "$appts" | sed 's/^/  /'
    printf '%s' "$RST"
  else
    printf ' %snothing scheduled%s\n' "$DIM" "$RST"
  fi
else
  printf ' %scalcurse not found, skipping%s\n' "$DIM" "$RST"
fi

hdr Disk
disk_out="$(df -h / | awk 'NR==2 { gsub(/%/, "", $5); print $5, $6": "$3" / "$2" ("$5"% used)" }')"
used_pct="${disk_out%% *}"
disk_line="${disk_out#* }"
if [ "$used_pct" -ge 80 ]; then
  disk_col="$RED"
else
  disk_col="$GRN"
fi
printf ' %s%s%s\n' "$disk_col" "$disk_line" "$RST"
