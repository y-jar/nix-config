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
      gnome.enable = false; # sets gnome [on by default]
      hyprland.enable = false; # sets hyprland
      niri.enable = true; # sets niri
      cinnamon.enable = false; # sets cinnamon
      cosmic = {
        enable = false; # sets cosmic desktop environment
        greeter = false; # sets cosmic login manager (disables GDM if enabled)
      };
      # =============[experience install]^^^

      # =============[hardware]
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
      bluetooth.enable = true; # sets blueman in home packages
      # [power management]
      tlp.enable = false; # NOTE: mutually exclusive with powerprofiles, pick one
      tlp.startChargeThreshold = 0;
      tlp.stopChargeThreshold = 100;
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
      # =============[software]^^^

      # =============[Server]
      server = {
        jellyfin = {
          enable = false; # sets jellyfin server
          juser = "candle"; # sets jellyfin user for perms for file access
        }; # end of jellyfin
        webjar = {
          enable = true; # ~5mib - self-hosted link page (nginx)
          port = 80;
        };
        komga.enable = false; # manga/comic server (port 25600)
        sleepyjar = {
          enable = false; # sets sleepy service
          interval = "weekly"; # sets interval for sleepy service
        };
        nixdraw = {
          enable = false; # sets up a self-hosted excalidraw Server.
          port = 3000; # sets the port for the excalidraw server
        };
      }; # end of server
      # =============[Server]^^^
    }; # end of sysSettings

  }; # end of config
}
