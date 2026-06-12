#!/usr/bin/env bash
# ref https://github.com/end-4/dots-hyprland/blob/main/dots/.config/hypr/hyprland/scripts/launch_first_available.sh
for cmd in "$@"; do
    [[ -z "$cmd" ]] && continue
    eval "command -v ${cmd%% *}" >/dev/null 2>&1 || continue
    eval "$cmd" &
    exit
done
