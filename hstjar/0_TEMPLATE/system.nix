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
# After you're done, head over to ./home.nix to configure your user!
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
    #            [system state version from first install]

    # Fill this out!
    sysSettings = {
      # =============[users]
      mainUser = "PLEASECHANGEME_USERNAME"; # primary user (gets home-manager)
      users = [ "PLEASECHANGEME_USERNAME" ]; # all users (main + any guests)
      adminUsers = [ "PLEASECHANGEME_USERNAME" ]; # users with sudo access
      userDescriptions = {
        PLEASECHANGEME_USERNAME = "NAME";
        # add more users as needed
      };
      # =============[users]^^^

      # =============[experience install]
      # [pick one or more if you know what you're doing] [sIZES ARE APPROXIMATE]
      gnome.enable = true; # ~800mib - full GNOME desktop
      hyprland.enable = true; # ~19mib - compositor only
      niri.enable = true; # ~20mib - compositor only
      cinnamon.enable = false; # ~800mib - full Cinnamon desktop
      cosmic = {
        enable = false; # COSMIC desktop environment
        greeter = false; # COSMIC login manager (disables GDM if enabled)
      };
      # =============[experience install]^^^

      # =============[hardware]
      nvidia.enable = false;
      # [kernel] pick one: "default", "latest", "cachyos-latest", "cachyos-bore", "cachyos-lts"
      kernel.variant = "default";

      # [TTY console font] bitmap fonts (set null for kernel default):
      #   "ter-116n"    - Terminus 16px (default-size, crisp)
      #   "ter-124n"    - Terminus 24px (medium, good for HiDPI)
      #   "ter-132n"    - Terminus 32px (large, very readable)
      #   "sun12x22"    - Sun Solaris style (classic server look)
      #   "latarcyrheb-sun32" - Large 32px with Cyrillic/Hebrew
      console = {
        font = "ter-132n";
      };
      boot.quiet = false;
      boot.fastMenu = false;

      neverSleep.enable = false; # disable system idle sleep
      bluetooth.enable = true; # ~10mib - sets blueman in home packages
      automount.enable = true; # auto-mount removable media (udisks2)
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
          nvidia.enable = false; # NVIDIA drivers (Vulkan + 32-bit)
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
        komga.enable = false; # manga/comic server (port 25600)
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
          enable = true; # ~5mib - self-hosted link page (nginx)
          port = 80;
        }; # end of webjar
      }; # end of server
      # =============[Server]^^^
    }; # end of sysSettings
  }; # end of config
}
