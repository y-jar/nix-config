{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 4;

        modules-left = [ "custom/launcher" "niri/workspaces" ];
        modules-center = [ "custom/title" "niri/window" ];
        modules-right = [ "cpu" "memory" "disk" "battery" "custom/powerprofile" "tray" "clock" "custom/power" ];

        "custom/launcher" = {
          format = "󱓞";
          on-click = "fuzzel";
          tooltip = false;
        };

        "niri/workspaces" = {
          format = "{name}";
          all-outputs = true;
        };

        "custom/title" = {
          format = "Jar";
          tooltip = false;
        };

        "niri/window" = {
          format = "{}";
          separate-outputs = true;
        };

        "cpu" = {
          format = "󰻠 {usage}%";
          interval = 3;
          tooltip = false;
        };

        "memory" = {
          format = "󰍛 {used:0.1f}G";
          interval = 3;
          tooltip-format = "{used:0.1f}G / {total:0.1f}G used";
        };

        "disk" = {
          format = "󰋊 {used} / {total}";
          path = "/";
          interval = 30;
          tooltip-format = "{used} used out of {total} on {path}";
        };

        # felt lazy with this, thanks AI
        "custom/battery" = {
          exec = pkgs.writeShellScript "waybar-battery" ''
            BAT=/sys/class/power_supply/BAT0
            capacity=$(cat $BAT/capacity 2>/dev/null || echo "?")
            status=$(cat $BAT/status 2>/dev/null || echo "?")
            power=$(cat $BAT/power_now 2>/dev/null || echo "0")
            energy_full=$(cat $BAT/energy_full 2>/dev/null || echo "1")
            energy_full_design=$(cat $BAT/energy_full_design 2>/dev/null || echo "1")
            drain=$(awk "BEGIN {printf \"%.1f\", $power / 1000000}")
            health=$(awk "BEGIN {printf \"%d\", ($energy_full / $energy_full_design) * 100}")
            
            # pick icon based on capacity
            if [ "$status" = "Charging" ]; then
              icon="󰂄"
            elif [ "$capacity" -ge 90 ]; then icon="󰁹"
            elif [ "$capacity" -ge 80 ]; then icon="󰂂"
            elif [ "$capacity" -ge 70 ]; then icon="󰂁"
            elif [ "$capacity" -ge 60 ]; then icon="󰂀"
            elif [ "$capacity" -ge 50 ]; then icon="󰁿"
            elif [ "$capacity" -ge 40 ]; then icon="󰁾"
            elif [ "$capacity" -ge 30 ]; then icon="󰁽"
            elif [ "$capacity" -ge 20 ]; then icon="󰁼"
            elif [ "$capacity" -ge 10 ]; then icon="󰁻"
            else icon="󰁺"
            fi

            echo "$icon $capacity%"
            echo "Drain: ''${drain}W | Health: ''${health}% | $status"
          '';
          interval = 30;
          return-type = "text";
          format = "{}";
          tooltip = true;
        };

        "custom/powerprofile" = {
          exec = pkgs.writeShellScript "waybar-powerprofile" ''
            profile=$(powerprofilesctl get)
            case $profile in
              performance)   echo '󰓅 perf' ;;
              balanced)      echo '󰾅 bal' ;;
              power-saver)   echo '󰌪 save' ;;
              *)             echo "? $profile" ;;
            esac
          '';
          interval = 5;
          on-click = pkgs.writeShellScript "waybar-powerprofile-pick" ''
            chosen=$(printf 'performance\nbalanced\npower-saver' | fuzzel --dmenu)
            [ -n "$chosen" ] && powerprofilesctl set "$chosen"
          '';
          tooltip = false;
        };

        "tray" = {
          spacing = 8;
          icon-size = 14;
        };

        "clock" = {
          format = "{:%H:%M — %a %d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "fuzzel --dmenu <<<$'Shutdown\nRestart\nSleep\nLogout' | xargs -I{} bash -c 'case \"{}\" in Shutdown) poweroff;; Restart) reboot;; Sleep) systemctl suspend;; Logout) niri msg action quit;; esac'";
        };
      };
    };

    style = ''
      * {
        font-family: "IntoneMono Nerd Font";
        font-size: 13px;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background: transparent;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        background: rgba(30, 30, 46, 0.80);
        border-radius: 8px;
        margin: 4px 4px;
        padding: 0 4px;
      }

      /* every direct module child gets its own subtle rounding */
      .modules-left > widget > *,
      .modules-center > widget > *,
      .modules-right > widget > * {
        border-radius: 6px;
        padding: 2px 8px;
        margin: 3px 2px;
      }

      #custom-launcher {
        color: #cba6f7;
        font-size: 16px;
      }

      #workspaces {
        padding: 0;
        margin: 0 2px;
      }

      #workspaces button {
        padding: 2px 8px;
        margin: 3px 2px;
        color: #6c7086;
        border-radius: 6px;
        background: transparent;
      }

      #workspaces button.active {
        color: #cba6f7;
        background: rgba(203, 166, 247, 0.20);
      }

      #custom-title {
        color: #cba6f7;
        font-weight: bold;
        letter-spacing: 1px;
      }

      #window {
        color: #89b4fa;
      }

      #cpu {
        color: #a6e3a1;
      }

      #memory {
        color: #89b4fa;
      }

      #disk {
        color: #f38ba8;
      }

      #battery {
        color: #a6e3a1;
      }

      #battery.warning {
        color: #f9e2af;
      }

      #battery.critical {
        color: #f38ba8;
      }

      #battery.charging,
      #battery.plugged {
        color: #a6e3a1;
      }

      #custom-powerprofile {
        color: #fab387;
      }

      #tray {
        padding: 0 6px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }

      #clock {
        color: #cdd6f4;
      }

      #custom-power {
        color: #f38ba8;
        font-size: 14px;
      }
    '';
  };
}