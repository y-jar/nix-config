{
  inputs,
  config,
  lib,
  ...
}:

{
  config = {
    system.stateVersion = "25.11"; # [CHANGE THIS]
    #            [system state version from first install]

    # Fill this out!
    sysSettings = {
      # =============[users] [list of users to create]
      users = [ "jar" ];
      adminUsers = [ "jar" ];
      # =============[users]^^^

      # =============[experience install]
      # [pick one or more if you know what you're doing]
      gnome.enable = true; # sets gnome [on by default]
      hyprland.enable = false; # sets hyprland
      niri.enable = true; # sets niri
      cinnamon.enable = false; # sets cinnamon
      cosmic = {
        enable = false; # sets cosmic desktop environment
        greeter = false; # sets cosmic login manager (disables GDM if enabled)
      };
      # =============[experience install]^^^

      # =============[hardware]
      nvidia.enable = false;
      # [kernel] pick one: "default", "latest", "cachyos-latest", "cachyos-bore", "cachyos-lts"
      kernel.variant = "cachyos-latest";

      # [TTY console font] bitmap fonts (set null for kernel default):
      #   "ter-116n"    - Terminus 16px (default-size, crisp)
      #   "ter-124n"    - Terminus 24px (medium, good for HiDPI)
      #   "ter-132n"    - Terminus 32px (large, very readable)
      #   "sun12x22"    - Sun Solaris style (classic server look)
      #   "latarcyrheb-sun32" - Large 32px with Cyrillic/Hebrew
      console = {
        font = "ter-132n";
      };

      bluetooth.enable = false; # sets blueman in home packages
      neverSleep.enable = false; # disable system idle sleep
      automount.enable = true; # auto-mount removable media (udisks2)
      # [power management]
      tlp.enable = false; # NOTE: mutually exclusive with powerprofiles, pick one
      tlp.startChargeThreshold = 0;
      tlp.stopChargeThreshold = 100;
      powerprofiles.enable = true;
      audio = {
        enable = true; # sets audio and adds some apps
        addon.enable = true; # adds my audio setup
      };
      # =============[hardware]^^^

      # =============[software]
      UseNixPkgsYoinks.enable = true;
      ai = {
        enable = true; # sets AI tools (Ollama, opencode, etc.)
        port = 11434;
        webui = {
          enable = false; # Open WebUI chat interface
          port = 8080;
        };
      };
      localsend.enable = true;
      flatpak.enable = false; # sets flatpak in the system [still needs to be enabled in user.nix]
      gaming = {
        drivers = {
          enable = true; # sets gaming drivers
          amd.enable = true; # sets amd drivers
          intel.enable = false; # sets intel drivers
          nvidia.enable = false; # sets nvidia drivers [NOT IMPLEMENTED]
        }; # end of drivers
        steam.enable = true; # sets steam and associated libraries for gaming, but not more important drivers
      }; # end of gaming
      virtcam.enable = true; # sets virtual camera for things like OBS
      virt = {
        enable = true; # sets virtualization and installs virtualization tools
        isInVM = false; # enable if this system is in a vm [virtual mechine]
      };
      # =============[software]^^^

      # =============[Server]
      server = {
        komga.enable = true; # manga/comic server (port 25600)
        jellyfin = {
          enable = false; # sets jellyfin server
          juser = "jar"; # sets jellyfin user for perms for file access
        }; # end of jellyfin
        nixdraw = {
          enable = true; # sets up a self-hosted excalidraw Server.
          port = 3000; # sets the port for the excalidraw server
          # =-=-=-=Usage:
          # LOCAL: http://localhost:3000
          # REMOTE: http://PH_Hostname:3000 or http://PH_IP_address:3000
        }; # end of nixdraw
        webjar = {
          enable = true; # self-hosted link page (nginx)
          port = 80;
        };
        sleepyjar = {
          enable = false; # sets sleepy service
          interval = "weekly"; # sets interval for sleepy service
        };
      }; # end of server
    }; # end of sysSettings

    # set user for git [be sure to replace all instances of USERNAME and NAME
    #                     with your actual username and name                 ]
    users.users.jar.description = "jar";
  }; # end of config
}
