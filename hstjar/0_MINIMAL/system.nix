# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host 0_MINIMAL: a lean system-level toggle sheet (<20GiB closure).
# -=-=-=-=-=-=-=-=-=-=-=
# This is the SYSTEM configuration for a minimal host.
# - Bare essentials: a window manager, a browser, a terminal.
# - Most heavy groups default OFF; flip what you need back on.
# - Replace every `PLEASECHANGEME_*` with real values.
# - Copy this whole folder to hstjar/<name>/ (via the installer) then set values.
# - All toggles are overridable — nothing here is force-locked.
{
  inputs,
  config,
  lib,
  ...
}:

{
  config = {
    system.stateVersion = "VersionNumber"; # [CHANGE THIS] [from first install]

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

      # =============[base / core packages]
      # Minimal: keep just the essentials. imaging (codecs) is OFF to save space.
      base = {
        coreTools = true; # neovim + nh + git — keep
        netArchives = true; # wget + curl + zip + rsync — small, keep
        fsTools = true; # psmisc + pciutils + usbutils — small, keep
        imaging = false; # image/video codec + thumbnail libs — OFF (large)
      };
      # =============[base / core packages]^^^

      # =============[experience install]
      # Minimal: a light WM only (mango by default). No full desktop, no GDM.
      cinnamon.enable = false;
      gnome.enable = false; # no GNOME (large)
      gdm.enable = false; # no GDM login manager; start the WM from TTY
      hyprland.enable = false;
      niri.enable = false;
      mango.enable = true; # default WM (small)
      cosmic = {
        enable = false;
        greeter = false;
      };
      # =============[experience install]^^^

      # =============[hardware]
      nvidia = {
        enable = false;
        open = false;
      };
      kernel.variant = "default";

      console = {
        font = "ter-132n";
      };
      boot.quiet = false;
      boot.fastMenu = false;
      boot.plymouth.enable = false;

      neverSleep.enable = false;
      bluetooth.enable = false;
      automount.enable = true; # auto-mount removable media (small, handy)
      tlp.enable = false;
      powerprofiles.enable = true;
      audio = {
        enable = true; # ~100mib - PipeWire (WM needs audio)
        addon.enable = false;
      };
      # =============[hardware]^^^

      # =============[software]
      UseNixPkgsYoinks.enable = false;
      fonts = {
        enable = true; # install fonts (master)
        minimal = true; # only terminal font + essentials (drops ~700MiB rounded-mgenplus)
      };
      # Minimal: AI = opencode only (NON-local models). Local llama + webui OFF
      # to avoid the ~2.7GiB ROCm backend. Flip ai.llama.enable on if you want it.
      ai = {
        enable = true; # opencode + (optionally) local llama
        llama = {
          enable = false; # OFF: no local llama.cpp (saves ~2.7GiB ROCm)
          gpu = "cpu"; # llama backend: rocm | cuda | cpu
        };
        port = 11434;
        webui = {
          enable = false;
          port = 8080;
        };
      };
      localsend.enable = false;
      espanso.enable = false;
      flatpak.enable = false;
      gaming = {
        drivers = {
          enable = false; # OFF: no Vulkan/Mesa game drivers
          amd.enable = false;
          intel.enable = false;
          nvidia.enable = false;
        };
        steam.enable = false;
      };
      virtcam.enable = false;
      virt = {
        enable = false;
        isInVM = false;
      };
      portal.enable = false;
      polkit.enable = false;
      # =============[software]^^^

      # =============[Server]
      server = {
        komga.enable = false;
        jellyfin = {
          enable = false;
          juser = "PLEASECHANGEME_USERNAME";
        };
        sleepyjar = {
          enable = false;
          interval = "weekly";
        };
        nixdraw = {
          enable = false;
          port = 3000;
        };
        webjar = {
          enable = false;
          port = 80;
        };
        vpn = {
          mullvad.enable = false;
        };
      }; # end of server
      # =============[Server]^^^
    }; # end of sysSettings
  }; # end of config
}
