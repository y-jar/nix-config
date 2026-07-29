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
      # =============[experience install]^^^

      # =============[hardware]
      # nvidia.enable = true;
      bluetooth.enable = true; # sets blueman in home packages
      neverSleep.enable = true; # disable system idle sleep
      # [power management]
      tlp.enable = false; # NOTE: mutually exclusive with powerprofiles, pick one
      powerprofiles.enable = true;
      audio = {
        enable = true; # sets audio and adds some apps
        addon.enable = false; # adds my audio setup
      };
      # =============[hardware]^^^

      # =============[software]
      UseNixPkgsYoinks.enable = false;
      ai.enable = false; # sets AI tools (Ollama, opencode, etc.)
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
      virt.enable = false; # sets virtualization and installs virtualization tools
      # =============[software]^^^

      # =============[Server]
      server = {
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
