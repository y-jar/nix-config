#*/-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Hi, This is the system configuration file for the picked host.
# If you're new here, just think of it as a checklist to fill out.
# Things to note:
# 1. You should change the stateVersion to the version you're using
# 2. You should change the home-manager state version to the version you're using
# 3. You should change all PLEASECHANGEME_* placeholders to your actual username
#   or values.
# 4. whether or not something is false or true is entirely up to you. enable what
#    you need!
#
# And remember, your configuration is yours to customize.
# After you're done, head over to ./user.nix to configure your user!
#*/-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

{
  inputs,
  config,
  lib,
  ...
}:

{
  config = {
    system.stateVersion = "VersionNumber"; # [CHANGE THIS]
    #            [note, this should be the same as the home manager state version]
    #            [system state version from first install]
    home-manager.users.PLEASECHANGEME_USERNAME.home.stateVersion = "HomeManagerVersionNumber"; # [CHANGE THIS]
    #            [home manager state version from first install]

    # Fill this out!
    sysSettings = {
      # =============[users] [list of users to create]
      users = [ "PLEASECHANGEME_USERNAME" ];
      adminUsers = [ "PLEASECHANGEME_USERNAME" ];
      # =============[users]^^^

      # =============[experience install]
      # [pick one or more if you know what you're doing] [sIZES ARE APPROXIMATE]
      gnome.enable = true; # ~800mib - full GNOME desktop
      hyprland.enable = true; # ~19mib - compositor only
      niri.enable = true; # ~20mib - compositor only
      cinnamon.enable = false; # ~800mib - full Cinnamon desktop
      # =============[experience install]^^^

      # =============[hardware]
      # nvidia.enable = true;
      # [kernel] pick one: "default", "latest", "cachyos-latest", "cachyos-bore", "cachyos-lts"
      kernel.variant = "default";
      bluetooth.enable = true; # ~10mib - sets blueman in home packages
      # [power management]
      # NOTE: tlp and powerprofiles are mutually exclusive, pick one
      # tlp is better for battery capping (laptops), powerprofiles gives a tray selector
      tlp.enable = false;
      tlp.startChargeThreshold = 0;   # 0 = always charge, 75 = resume charging at 75%
      tlp.stopChargeThreshold = 100;  # 100 = no cap, 80 = stop charging at 80%
      powerprofiles.enable = true;
      audio = {
        enable = true; # ~100mib - PipeWire + audio tools
        addon.enable = false; # adds my audio setup
      };
      # =============[hardware]^^^

      # =============[software]
      UseNixPkgsYoinks.enable = false;
      ai = {
        enable = false; # ~2gib - Ollama + models If you run `pull-models` in terminal
        port = 11434;
        webui = {
          enable = false; # Open WebUI chat interface (~2gib)
          port = 8080;
        };
      };
      localsend.enable = true; # ~30mib - local file sharing
      flatpak.enable = false; # ~10mib - flatpak support [still needs to be enabled in user.nix]
      gaming = {
        drivers = {
          enable = true; # ~1.5gib - Vulkan + Mesa + codecs
          amd.enable = false; # AMD specific drivers
          intel.enable = false; # Intel specific drivers
          nvidia.enable = false; # NVIDIA drivers [NOT IMPLEMENTED]
        }; # end of drivers
        steam.enable = true; # ~2gib - Steam client + 32-bit libs
      }; # end of gaming
      virtcam.enable = false; # ~5mib - virtual camera for OBS
      virt = {
        enable = false; # ~1gib - QEMU + libvirtd + tools
        isInVM = false; # enable if this system is in a vm
      }; # end of virt
      # =============[software]^^^

      # =============[Server]
      server = {
        jellyfin = {
          enable = false; # sets jellyfin server
          juser = "PLEASECHANGEME_USERNAME"; # sets jellyfin user for perms for file access
        }; # end of jellyfin
        sleepyjar = {
          enable = false; # sets sleepy service
          interval = "weekly"; # sets interval for sleepy service
          # some* options for sleepy service:
          # daily: reboots every midnight
          # weekly: reboots every Sunday at midnight
          # "Fri 03:00:00": reboots every Friday at 3am
          # "*-*-1,15 02:00:00": reboots on the 1st and 15th of every month at 2am
        }; # end of sleepyjar
        nixdraw = {
          enable = false; # sets up a self-hosted excalidraw Server.
          port = 3000; # sets the port for the excalidraw server
          # =-=-=-=Usage:
          # LOCAL: http://localhost:3000
          # REMOTE: http://PH_Hostname:3000 or http://PH_IP_address:3000
        }; # end of nixdraw
        webjar = {
          enable = false; # ~5mib - self-hosted link page (nginx)
          port = 80;
        }; # end of webjar
      }; # end of server
      # =============[Server]^^^
    }; # end of sysSettings

    # set user for git [be sure to replace all instances of USERNAME and NAME
    #                     with your actual username and name                 ]
    users.users.PLEASECHANGEME_USERNAME.description = "NAME";
    home-manager.users.PLEASECHANGEME_USERNAME.usrSettings = {
      name = "PLEASECHANGEME_NAME";
      email = "PLEASECHANGEME_EMAIL";
    };
  }; # end of config
}
