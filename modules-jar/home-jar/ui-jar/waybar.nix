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
        modules-left = [ "custom/launcher" "niri/workspaces" "custom/folders" ];
        modules-center = [ "clock" ];
        modules-right = [ "battery" "pulseaudio" "custom/power" ];

        "custom/launcher" = {
          format = "󱓞"; 
          on-click = "fuzzel";
          tooltip = false;
        };

        "custom/folders" = {
          format = "󰉋";
          on-click = "thunar ~"; # Or your preferred file manager
          tooltip = true;
          tooltip-format = "Open Home Directory";
        };

        "niri/workspaces" = {
          format = "{name}";
          all-outputs = true;
        };

        "clock" = {
          format = "{:%H:%M - %a %d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "custom/power" = {
          format = "";
          on-click = "fuzzel --dmenu <<<'Shutdown\nRestart\nSleep\nLogout' | xargs -I{} bash -c 'case {} in Shutdown) poweroff;; Restart) reboot;; Sleep) systemctl suspend;; Logout) niri msg action quit;; esac'";
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
          background-color: rgba(43, 38, 34, 0.75); /* Warm dusty brown with 75% opacity */
          color: #e6dfd3;
          transition-property: background-color;
          transition-duration: .5s;
      }

      #workspaces button {
          padding: 0 5px;
          color: #a89984;
      }

      #workspaces button.active {
          color: #d79921; /* Gold/Earth highlight */
          border-bottom: 2px solid #d79921;
      }

      #custom-launcher, #custom-folders, #custom-power {
          padding: 0 10px;
          color: #ebdbb2;
      }
    '';
  };
}