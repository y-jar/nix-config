# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Core base: system packages, tweaks, boot options (quiet/fastMenu), zsh, timezone.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.sysset.boot;
  base = config.sysset.base;

  # Derived flag: does this host run any window manager / desktop environment?
  # Headless/server/VM hosts (no WM/DE) skip WM-dependent session variables.
  hasDesktop =
    (config.sysset.niri.enable or false)
    || (config.sysset.hyprland.enable or false)
    || (config.sysset.gnome.enable or false)
    || (config.sysset.cinnamon.enable or false)
    || (config.sysset.cosmic.enable or false);
in
{
  options = {
    sysset.boot = {
      quiet = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Silence kernel/udev/systemd startup logs (quiet, udev.log_level=3, systemd.show_status=auto, consoleLogLevel=3). Default: false so users see the boot sequence.";
      };
      fastMenu = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Set boot loader timeout to 1 second. Default: false (systemd-boot default of 5 seconds).";
      };
      grubDevice = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "GRUB install device (e.g. /dev/sda or /dev/disk/by-id/...). Required on hosts using boot.loader.grub; leave null on systemd-boot hosts.";
      };
    };

    # Always-on base package groups. Each defaults to true so existing hosts are
    # unaffected; minimal hosts can opt out to keep the system/download small.
    sysset.base = {
      coreTools = lib.mkEnableOption "editor + nh + git core CLI tools";
      netArchives = lib.mkEnableOption "wget/curl/zip/rar/rsync archive+net tools";
      fsTools = lib.mkEnableOption "psmisc/pciutils/usbutils/killall/ntfs3g fs tools";
      imaging = lib.mkEnableOption "image/video codec + thumbnail support stack";
    };
  }; # end of options

  config = {

    time.timeZone = "America/New_York";

    # Use zsh
    # NOTE: at a point i ran into a weird zsh error, run this if commands dont work
    #export PATH=/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$HOME/.local/bin:$PATH
    programs = {
      zsh.enable = true;
      dconf.enable = true; # key/value preference storage (GCONF successor)
      evince.enable = true; # PDF thumbnailing
      # tell NixOS to include these in the generated pixbuf loaders cache
      gdk-pixbuf.modulePackages = lib.mkIf base.imaging [
        pkgs.librsvg
        pkgs.webp-pixbuf-loader
      ];
    };
    environment = {
      shells = [ pkgs.zsh ];
      # WM/DE-dependent session variables. Skipped on headless/server/VM hosts.
      sessionVariables = lib.optionalAttrs hasDesktop {
        NIXOS_OZONE_WL = "1"; # nudges Electron/Chrome apps to use Wayland
        QT_QPA_PLATFORMTHEME = "qtct";
        QT_QPA_PLATFORMTHEME_QT6 = "qtct";
      };
      # ==================================System Packages========================================
      # List packages installed in system profile.
      # use https://search.nixos.org/ to find more packages (and options).
      systemPackages = lib.mkMerge [
        # [base]
        (lib.mkIf base.coreTools [
          pkgs.neovim # extensible terminal editor
          pkgs.vim # classic terminal editor
          pkgs.nh # nix helper (builds/deploys this config)
          pkgs.git # version control
          pkgs.eza
        ])

        # [Archives & net serv]
        (lib.mkIf base.netArchives [
          pkgs.wget # file retrieval over HTTP/HTTPS/FTP
          pkgs.curl # URL-transfer CLI
          pkgs.zip # zip archiver
          pkgs.unzip # zip extractor
          pkgs.rar # rar archiver
          pkgs.rsync # incremental file transfer
        ])

        # [tools & file system]
        (lib.mkIf base.fsTools [
          pkgs.psmisc # killall + fuser
          pkgs.pciutils # lspci
          pkgs.usbutils # lsusb
          pkgs.killall # kill by name
          pkgs.ntfs3g # read/write NTFS
        ])

        # [image format support]
        (lib.mkIf base.imaging [
          pkgs.webp-pixbuf-loader # webp support for GTK apps
          pkgs.libheif # heif/avif support
          pkgs.libjxl # jpeg-xl support
          pkgs.poppler-utils # PDF utilities
          pkgs.poppler # PDF rendering lib
          pkgs.ffmpegthumbnailer # video + image thumbnails
          pkgs.gdk-pixbuf # image loading/manipulation lib
          pkgs.librsvg # svg support + pixbuf loader rebuild
          pkgs.libjpeg # jpeg support
          pkgs.libpng # png support
          pkgs.libtiff # tiff support
        ])
      ]; # end of environment.systemPackages
    };
    users.defaultUserShell = pkgs.zsh; # default shell for new users

    services = {
      # ==================================Tweaks========================================
      gnome.gnome-keyring.enable = true; # desktop password/keyring storage
      tumbler.enable = true; # image/video thumbnail service

      # [perf / cleanliness]
      dbus.implementation = "broker"; # faster, lighter D-Bus than the reference implementation
      speechd.enable = lib.mkForce false; # text-to-speech daemon (off)
    };

    # ==================================Boot========================================
    boot = {
      initrd.systemd.enable = true; # systemd in the initrd
      loader.timeout = lib.mkIf cfg.fastMenu 1; # 1s when fastMenu, else systemd-boot default (5s)
      loader.grub.device = lib.mkIf (cfg.grubDevice != null) cfg.grubDevice; # GRUB install target (per-host option)
      consoleLogLevel = lib.mkIf cfg.quiet 3; # quieter kernel log
      kernelParams = lib.mkIf cfg.quiet [
        "quiet"
        "udev.log_level=3"
        "systemd.show_status=auto"
      ]; # end of kernelParams
    }; # end of boot
  }; # end of config
}
