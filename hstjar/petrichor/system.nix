# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host 0_TEMPLATE: system-level toggle sheet (sysSettings).
# -=-=-=-=-=-=-=-=-=-=-=
# This is the SYSTEM configuration file for this host.
# - It's a checklist to fill out: enable what you need, leave the rest off.
# - Replace every `PLEASECHANGEME_*` with real values.
# - Set `system.stateVersion` to the NixOS version of first install.
# - Pair options here with matching user toggles in ./home.nix.
{
  inputs,
  config,
  lib,
  ...
}:

{
  config = {
    system.stateVersion = "26.05"; # [CHANGE THIS] [from first install]

    # Fill this out!
    sysSettings = {
      # =============[users]
      mainUser = "kway"; # primary user (gets home-manager)
      users = [ "kway" ]; # all users (main + any guests)
      adminUsers = [ "kway" ]; # users with sudo access
      userDescriptions = {
        kway = "kt";
        # add more users as needed
      };
      # =============[users]^^^

      # =============[base / core packages]
      # Always-on package groups. Default true keeps a useful baseline; disable
      # groups you don't need to shrink the system/download.
      base = {
        coreTools = true; # neovim + nh + git
        netArchives = true; # wget + curl + zip + rar + rsync
        fsTools = true; # psmisc + pciutils + usbutils + ntfs3g
        imaging = true; # image/video codec + thumbnail support
      };
      # =============[base / core packages]^^^

      # =============[experience install]
      # [pick one or more if you know what you're doing] [sizes approximate]
      cinnamon.enable = false; # ~800mib - full Cinnamon desktop
      gnome.enable = true; # ~800mib - full GNOME desktop
      gdm.enable = true; # sets GDM login manager
      hyprland.enable = false; # ~19mib - compositor only
      niri.enable = true; # ~20mib - compositor only
      cosmic = {
        enable = false; # COSMIC desktop environment
        greeter = false; # COSMIC login manager (disables GDM if enabled)
      };
      # =============[experience install]^^^

      # =============[hardware]
      nvidia = {
        enable = false; # NVIDIA GPU drivers and CUDA support
        open = false; # open-source NVIDIA kernel module (Turing/RTX 2000+ only)
      };
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
      boot.plymouth.enable = false; # custom logo boot splash via plymouth

      neverSleep.enable = false; # disable system idle sleep
      bluetooth.enable = false; # ~10mib - sets blueman in home packages
      automount.enable = true; # auto-mount removable media (udisks2)
      # [power management]
      # NOTE: tlp and powerprofiles are mutually exclusive, pick one
      # tlp is better for battery capping (laptops), powerprofiles gives a tray selector
      tlp.enable = false;
      tlp.startChargeThreshold = 0; # 0 = always charge, 75 = resume charging at 75%
      tlp.stopChargeThreshold = 100; # 100 = no cap, 80 = stop charging at 80%
      tlp.cpuEppOnBattery = "balance_power"; # (default|performance|balance_performance|balance_power|power)
      tlp.platformProfileOnBattery = "balanced"; # (cool|quiet|balanced|performance)
      tlp.pcieAspmOnBattery = "default"; # (default|performance|powersave|powersupersave)
      powerprofiles.enable = true;
      audio = {
        enable = true; # ~100mib - PipeWire + audio tools
        addon.enable = false; # adds my audio setup
      };
      # =============[hardware]^^^

      # =============[software]
      unfree.enable = true; # allow unfree packages (spotify, chromium, vscodium, steam, ...)
      UseNixPkgsYoinks.enable = false;
      ai = {
        enable = false; # ~2gib - llama.cpp + models (auto-downloaded via models-preset)
        gpu = "rocm"; # llama.cpp backend: rocm (AMD) | cuda (NVIDIA) | cpu
        port = 11434;
        webui = {
          enable = false; # Open WebUI chat interface (~2gib)
          port = 8080;
        };
      };
      localsend.enable = true; # ~30mib - local file sharing
      espanso.enable = false; # ~30mib - espanso daemon + Wayland security wrapper
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
      virtcam.enable = true; # ~5mib - virtual camera for OBS
      virt = {
        enable = true; # ~1gib - QEMU + libvirtd + tools
        isInVM = false; # enable if this system is in a vm
      }; # end of virt
      portal.enable = true; # XDG portal file pickers
      polkit.enable = true; # polkit authentication agent (gnome polkit)
      # =============[software]^^^

      # =============[Server]
      server = {
        komga.enable = false; # manga/comic server (port 25600)
        jellyfin = {
          enable = false; # sets jellyfin server.  note: the default port is 8096.
          juser = "kway"; # sets jellyfin user for perms for file access
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
        vpn = {
          mullvad.enable = false;
        };
      }; # end of server
      # =============[Server]^^^
    }; # end of sysSettings
  }; # end of config
}
