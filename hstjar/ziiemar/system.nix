# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host ziiemar: system-level toggle sheet (sysset).
# -=-=-=-=-=-=-=-=-=-=-=
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  config = {
    system.stateVersion = "25.11"; # [CHANGE THIS]
    #            [system state version from first install]

    # [host hardware quirk] Drop the OLED panel to 48Hz on battery, 120Hz on AC,
    # to save power. (Moved here from the old home.nix so user.nix stays a pure
    # toggle sheet that both backends can read.)
    systemd.user.services.niri-refresh-on-battery = {
      description = "Switch niri eDP-1 refresh rate based on power source";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      environment = {
        WAYLAND_DISPLAY = "wayland-1";
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.writeShellScriptBin "niri-refresh-on-battery" ''
          set -eu
          last=""
          while :; do
            ac=$(cat /sys/class/power_supply/AC/online 2>/dev/null || echo 0)
            if [ "$ac" = "0" ]; then
              mode="2880x1800@48.001"
            else
              mode="2880x1800@120.001"
            fi
            if [ "$mode" != "$last" ]; then
              niri msg output eDP-1 mode "$mode" 2>/dev/null || true
              last="$mode"
            fi
            sleep 10
          done
        ''}/bin/niri-refresh-on-battery";
        Restart = "on-failure";
        RestartSec = 10;
      };
    };

    # Fill this out!
    sysset = {
      # =============[users]
      mainUser = "jar";
      users = [ "jar" ];
      adminUsers = [ "jar" ];
      userDescriptions = {
        jar = "jar";
      };
      # =============[users]^^^

      # =============[base / core packages]
      base = {
        coreTools = true;
        netArchives = true;
        fsTools = true;
        imaging = true;
      };
      # =============[base / core packages]^^^

      # =============[experience install]
      # [pick one or more if you know what you're doing]
      cinnamon.enable = false; # sets cinnamon
      gnome.enable = true; # sets gnome [on by default]
      gdm.enable = true; # sets GDM login manager
      hyprland.enable = false; # sets hyprland
      niri.enable = true; # sets niri
      mango.enable = false; # sets mango (mangowm)
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
      # NOTE: tlp and powerprofiles are mutually exclusive, pick one
      tlp.enable = true;
      tlp.startChargeThreshold = 0;
      tlp.stopChargeThreshold = 80; # no hard cap on HP consumer; BIOS "Adaptive Battery Optimizer" is adaptive
      tlp.cpuEppOnBattery = "power"; # max battery savings (balance_power = default)
      tlp.platformProfileOnBattery = "low-power"; # (cool|quiet|balanced|performance)
      tlp.pcieAspmOnBattery = "powersave"; # deeper PCIe idle states
      # powerprofiles.enable = true;
      audio = {
        enable = true; # sets audio and adds some apps
        addon.enable = false; # adds my audio setup
      };
      # =============[hardware]^^^

      # =============[software]
      unfree.enable = true; # allow unfree packages (spotify, chromium, vscodium, steam, ...)
      UseNixPkgsYoinks.enable = false;
      ai = {
        enable = true; # sets AI tools (llama.cpp, opencode, etc.)
        llama = {
          enable = true; # local llama.cpp (set false to use opencode/non-local only)
          gpu = "rocm"; # llama.cpp backend: rocm (AMD) | cuda (NVIDIA) | cpu
        };
        port = 11434;
        webui = {
          enable = false; # Open WebUI chat interface
          port = 8080;
        };
      };
      localsend.enable = true;
      espanso.enable = false; # espanso daemon + Wayland security wrapper
      flatpak.enable = true; # sets flatpak in the system [still needs to be enabled in user.nix]
      gaming = {
        drivers = {
          enable = true; # sets gaming drivers
          amd.enable = false; # sets amd drivers
          intel.enable = true; # sets intel drivers
          nvidia.enable = false; # sets nvidia drivers (Vulkan + 32-bit)
        }; # end of drivers
        steam.enable = true; # sets steam and associated libraries for gaming, but not more important drivers
      }; # end of gaming
      virtcam.enable = false; # sets virtual camera for things like OBS
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
          enable = false; # sets up a self-hosted excalidraw Server.
          port = 3000; # sets the port for the excalidraw server
        };
        webjar = {
          enable = true; # ~5mib - self-hosted link page (nginx)
          port = 80;
        };
      }; # end of server
    }; # end of sysset

  }; # end of config
}
