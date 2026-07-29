{
  inputs,
  config,
  lib,
  ...
}:

{
  config = {
    system.stateVersion = "26.05"; # [CHANGE THIS]
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
      hyprland.enable = false; # sets hyprland ~19MiB
      niri.enable = true; # sets niri
      cinnamon.enable = false; # sets cinnamon
      cosmic = {
        enable = false; # sets cosmic desktop environment
        greeter = false; # sets cosmic login manager (disables GDM if enabled)
      };
      # =============[experience install]^^^

      # =============[hardware]
      # nvidia.enable = true;
      # [kernel] pick one: "default", "latest", "cachyos-latest", "cachyos-bore", "cachyos-lts"
      kernel.variant = "default";
      bluetooth.enable = true; # sets blueman in home packages
      automount.enable = true; # auto-mount removable media (udisks2)
      neverSleep.enable = true; # disable system idle sleep
      # [power management]
      tlp.enable = false; # NOTE: mutually exclusive with powerprofiles, pick one
      tlp.startChargeThreshold = 0;
      tlp.stopChargeThreshold = 100;
      powerprofiles.enable = true;
      audio = {
        enable = true; # sets audio and adds some apps
        addon.enable = false; # adds my audio setup
      };
      # =============[hardware]^^^

      # =============[software]
      UseNixPkgsYoinks.enable = false;
      ai = {
        enable = false; # sets AI tools (Ollama, opencode, etc.)
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
          amd.enable = false; # sets amd drivers
          intel.enable = true; # sets intel drivers
          nvidia.enable = false; # sets nvidia drivers [NOT IMPLEMENTED]
        }; # end of drivers
        steam.enable = false; # sets steam and associated libraries for gaming, but not more important drivers
      }; # end of gaming
      virtcam.enable = false; # sets virtual camera for things like OBS
      virt = {
        enable = false; # sets virtualization and installs virtualization tools
        isInVM = false; # enable if this system is in a vm
      };
      # =============[software]^^^

      # =============[Server]
      server = {
        komga.enable = false; # manga/comic server (port 25600)
        jellyfin = {
          enable = true; # sets jellyfin server
          juser = "jar"; # sets jellyfin user for perms for file access
        }; # end of jellyfin
        sleepyjar = {
          enable = true; # sets sleepy service
          interval = "daily"; # sets interval for sleepy service
          # some* options for sleepy service:
          # daily: reboots every midnight
          # weekly: reboots every Sunday at midnight
          # "Fri 03:00:00": reboots every Friday at 3am
          # "*-*-1,15 02:00:00": reboots on the 1st and 15th of every month at 2am
        }; # end of sleepyjar
        nixdraw = {
          enable = false; # sets up a self-hosted excalidraw Server.
          port = 3000; # sets the port for the excalidraw server
        };
        webjar = {
          enable = true; # self-hosted link page (nginx)
          port = 80;
        };
      }; # end of server
      # =============[Server]^^^
    }; # end of sysSettings

    # set user for git [be sure to replace all instances of USERNAME and NAME
    #                     with your actual username and name                 ]
    users.users.jar.description = "jar";
  }; # end of config
}
