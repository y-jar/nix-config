{ config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        margin-top = 10;
        margin-left = 100;
        margin-right = 100;
        exclusive = true;
        fixed-center = true;

        modules-left = [
	  # options: can swap "wlr/taskbar" for "sway/workspaces"
          "sway/workspaces"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "pulseaudio"
          "network"
          "battery"
          "tray"
        ];

        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 18;
          on-click = "activate";
          on-click-right = "close";
          tooltip = true;
          tooltip-format = "{title}";
        };

        "clock" = {
          format = "{:%H:%M  %a %d %b}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "muted";
          format-icons = {
            default = [ "▁" "▄" "█" ];
          };
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
        };

        "network" = {
          format-wifi = "WiFi {signalStrength}%";
          format-ethernet = "ETH";
          format-disconnected = "No Network";
          tooltip-format = "{ifname}: {ipaddr}";
        };

        "battery" = {
          format = "BAT {capacity}%";
          format-charging = "CHR {capacity}%";
          format-full = "FULL";
          states = {
            warning = 30;
            critical = 15;
          };
        };

        "tray" = {
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        font-family: monospace;
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
        box-shadow: none;
      }

      window#waybar {
        background: transparent;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        background: rgba(20, 20, 20, 0.88);
        border-radius: 12px;
        padding: 4px 12px;
        margin: 4px 6px;
      }

      #taskbar,
      #clock,
      #pulseaudio,
      #network,
      #battery,
      #tray {
        padding: 0 8px;
        color: #e0e0e0;
      }

      #battery.warning {
        color: #f0a500;
      }

      #battery.critical {
        color: #e05050;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        color: #f0a500;
      }
    '';
  };
}
