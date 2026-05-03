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
        modules-right = [ "cpu" "memory" "disk" "tray" "clock" "custom/power" ];

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

        "tray" = {
          spacing = 8;
          icon-size = 14;
        };

        "clock" = {
          format = "{:%H:%M — %a %d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "custom/power" = {
          format = "";
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
        padding: 0 8px;
      }

      #custom-launcher {
        color: #cba6f7;
        padding: 0 10px;
        font-size: 16px;
      }

      #workspaces button {
        padding: 0 6px;
        color: #6c7086;
        border-radius: 4px;
      }

      #workspaces button.active {
        color: #cba6f7;
        background: rgba(203, 166, 247, 0.20);
        border-radius: 4px;
      }

      #custom-title {
        color: #cba6f7;
        font-weight: bold;
        padding: 0 6px 0 10px;
        letter-spacing: 1px;
      }

      #window {
        color: #89b4fa;
        padding: 0 10px 0 4px;
      }

      #cpu {
        color: #a6e3a1;
        padding: 0 6px;
      }

      #memory {
        color: #89b4fa;
        padding: 0 6px;
      }

      #disk {
        color: #f38ba8;
        padding: 0 6px;
      }

      #tray {
        padding: 0 8px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }

      #clock {
        color: #cdd6f4;
        padding: 0 8px;
      }

      #custom-power {
        color: #f38ba8;
        padding: 0 10px;
        font-size: 14px;
      }
    '';
  };
}