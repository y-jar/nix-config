#!/usr/bin/env bash
# powermenu.sh
# Usage: powermenu

CHOICE=$(printf "  Shutdown\n  Restart\n  Suspend\n  Logout\n  Kill Window" | fuzzel --dmenu --lines=5 --prompt="Power > ")

case "$CHOICE" in
  "  Shutdown") systemctl poweroff ;;
  "  Restart")  systemctl reboot ;;
  "  Suspend")  systemctl suspend ;;
  "  Logout")
    if [ "$XDG_CURRENT_DESKTOP" = "niri" ]; then
      niri msg action quit --skip-confirmation
    elif [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
      hyprctl dispatch exit
    fi
    ;;
  "  Kill Window")
    ps -u "$USER" -o pid=,comm=,%cpu=,%mem= --sort=-%cpu \
      | fuzzel --dmenu --lines=10 --prompt="Kill > " \
      | awk '{print $1}' | xargs -r kill
    ;;
  *) exit 0 ;;  # escaped or picked nothing
esac
