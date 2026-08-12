#*/-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Hi, This is the system configuration file for the picked host.
# If you're new here, just think of it as a checklist to fill out.
# Things to note:
# 1. You should change the stateVersion to the version you're using
# 2. You should change the home-manager state version to the version you're using
# 3. whether or not something is false or true is entirely up to you. enable what
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
    system.stateVersion = "26.05"; # [CHANGE THIS]
    #            [system state version from first install]

    # Fill this out!
    sysSettings = {
      # =============[users]
      mainUser = "jar";
      users = [ "jar" ];
      adminUsers = [ "jar" ];
      userDescriptions = {
        jar = "jar";
      };
      # =============[users]^^^

      # =============[experience install]
      # [pick one or more if you know what you're doing]
      cinnamon.enable = false; # sets cinnamon
      gnome.enable = true; # sets gnome [on by default]
      gdm.enable = true; # headless server, no login screen
      hyprland.enable = false; # sets hyprland ~19MiB
      niri.enable = false; # sets niri
      cosmic = {
        enable = false; # sets cosmic desktop environment
        greeter = false; # sets cosmic login manager (disables GDM if enabled)
      };
      # =============[experience install]^^^

      # =============[hardware]
      nvidia = {
        enable = false; # NVIDIA GPU drivers and CUDA support
        open = false; # open-source NVIDIA kernel module (Turing/RTX 2000+ only)
      };
      # [kernel] pick one: "default", "latest", "cachyos-latest", "cachyos-bore", "cachyos-lts"
      kernel.variant = "latest";
      # [TTY console font] bitmap fonts (set null for kernel default):
      #   "ter-116n"    - Terminus 16px (default-size, crisp)
      #   "ter-124n"    - Terminus 24px (medium, good for HiDPI)
      #   "ter-132n"    - Terminus 32px (large, very readable)
      #   "sun12x22"    - Sun Solaris style (classic server look)
      #   "latarcyrheb-sun32" - Large 32px with Cyrillic/Hebrew
      console = {
        font = "ter-132n";
      };
      boot.quiet = false; # silence kernel/udev/systemd startup logs
      boot.fastMenu = false; # set boot loader timeout to 1 second
      neverSleep.enable = true; # disable system idle sleep
      bluetooth.enable = false; # sets blueman in home packages
      automount.enable = true; # auto-mount removable media (udisks2)
      # [power management]
      tlp.enable = false; # NOTE: mutually exclusive with powerprofiles, pick one
      tlp.startChargeThreshold = 0;
      tlp.stopChargeThreshold = 100;
      tlp.cpuEppOnBattery = "balance_power"; # (default|performance|balance_performance|balance_power|power)
      tlp.platformProfileOnBattery = "balanced"; # (cool|quiet|balanced|performance)
      tlp.pcieAspmOnBattery = "default"; # (default|performance|powersave|powersupersave)
      powerprofiles.enable = false;
      audio = {
        enable = true; # sets audio and adds some apps
        addon.enable = false; # adds my audio setup
      };
      # =============[hardware]^^^

      # =============[software]
      UseNixPkgsYoinks.enable = false;
      ai = {
        enable = false; # sets AI tools (llama.cpp, opencode, etc.)
        port = 11434;
        webui = {
          enable = false; # Open WebUI chat interface
          port = 8080;
        };
      };
      localsend.enable = true; # sets localsend in the system
      flatpak.enable = false; # sets flatpak in the system [still needs to be enabled in user.nix]
      gaming = {
        drivers = {
          enable = true; # sets gaming drivers
          amd.enable = false; # sets amd drivers
          intel.enable = false; # sets intel drivers
          nvidia.enable = false; # sets nvidia drivers (Vulkan + 32-bit)
        }; # end of drivers
        steam.enable = false; # sets steam and associated libraries for gaming, but not more important drivers
      }; # end of gaming
      virtcam.enable = false; # sets virtual camera for things like OBS
      virt = {
        enable = false; # sets virtualization and installs virtualization tools
        isInVM = true; # enable if this system is in a vm [virtual mechine]
      };
      portal.enable = true; # XDG portal file pickers
      polkit.enable = true; # polkit authentication agent (gnome polkit)
      # =============[software]^^^

      # =============[Server]
      server = {
        komga.enable = true; # manga/comic server (port 25600)
        jellyfin = {
          enable = true; # sets jellyfin server.  note: the default port is 8096.
          juser = "jar"; # sets jellyfin user for perms for file access
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
          enable = true; # sets up a self-hosted excalidraw Server.
          port = 3000; # sets the port for the excalidraw server
        };
        webjar = {
          enable = true; # ~5mib - self-hosted link page (nginx)
          port = 80;
        };
      }; # end of server
      # =============[Server]^^^
    }; # end of sysSettings
  }; # end of config
}
