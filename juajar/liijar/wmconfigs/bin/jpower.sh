#!/usr/bin/env bash
# powermenu.sh
# Usage: powermenu

CHOICE=$(printf "  Shutdown\n  Restart\n  Logout" | fuzzel --dmenu --lines=3 --prompt="Power > ")

case "$CHOICE" in
  "  Shutdown") systemctl poweroff ;;
  "  Restart")  systemctl reboot ;;
  "  Logout")
    if [ "$XDG_CURRENT_DESKTOP" = "niri" ]; then
      niri msg action quit --skip-confirmation
    elif [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
      hyprctl dispatch exit
    fi
    ;;
  *) exit 0 ;;  # escaped or picked nothing
esac
