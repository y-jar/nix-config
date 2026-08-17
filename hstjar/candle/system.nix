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
      # =============[users]
      mainUser = "wax";
      users = [ "wax" ];
      adminUsers = [ "wax" ];
      userDescriptions = {
        wax = "wax";
      };
      # =============[users]^^^

      # =============[experience install]
      # [pick one or more if you know what you're doing]
      cinnamon.enable = false; # sets cinnamon
      gnome.enable = false; # sets gnome [on by default]
      gdm.enable = true; # sets GDM login manager
      hyprland.enable = false; # sets hyprland
      niri.enable = true; # sets niri
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
      kernel.variant = "default";
      neverSleep.enable = false; # disable system idle sleep
      automount.enable = true; # auto-mount removable media (udisks2)
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
      boot.plymouth.enable = true; # custom boot splash logo
      bluetooth.enable = true; # sets blueman in home packages
      # [power management]
      tlp.enable = false; # NOTE: mutually exclusive with powerprofiles, pick one
      tlp.startChargeThreshold = 0;
      tlp.stopChargeThreshold = 100;
      tlp.cpuEppOnBattery = "balance_power"; # (default|performance|balance_performance|balance_power|power)
      tlp.platformProfileOnBattery = "balanced"; # (cool|quiet|balanced|performance)
      tlp.pcieAspmOnBattery = "default"; # (default|performance|powersave|powersupersave)
      powerprofiles.enable = true; # sets power profiles daemon [what i prefer]
      audio = {
        enable = true; # sets audio and adds some apps
        addon.enable = false; # adds my audio setup
      };
      # =============[hardware]^^^

      # =============[software]
      UseNixPkgsYoinks.enable = false;
      ai = {
        enable = true; # sets AI tools (llama.cpp, opencode, etc.)
        port = 11434;
        webui = {
          enable = true; # Open WebUI chat interface
          port = 8080;
        };
      };
      localsend.enable = true;
      espanso.enable = true; # espanso daemon + Wayland security wrapper
      flatpak.enable = false; # sets flatpak in the system [still needs to be enabled in user.nix]
      gaming = {
        drivers = {
          enable = true; # sets gaming drivers
          amd.enable = true; # sets amd drivers
          intel.enable = false; # sets intel drivers
          nvidia.enable = false; # sets nvidia drivers (Vulkan + 32-bit)
        }; # end of drivers
        steam.enable = true; # sets steam and associated libraries for gaming, but not more important drivers
      }; # end of gaming
      virtcam.enable = true; # sets virtual camera for things like OBS
      virt = {
        enable = true; # sets virtualization and installs virtualization tools
        isInVM = false; # enable if this system is in a vm
      };
      portal.enable = true; # XDG portal file pickers
      polkit.enable = true; # polkit authentication agent (gnome polkit)
      # =============[software]^^^

      # =============[Server]
      server = {
        komga.enable = false; # manga/comic server (port 25600)
        jellyfin = {
          enable = false; # sets jellyfin server
          juser = "candle"; # sets jellyfin user for perms for file access
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
