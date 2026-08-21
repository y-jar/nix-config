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
  cfg = config.sysSettings.boot;
  base = config.sysSettings.base;

  # Derived flag: does this host run any window manager / desktop environment?
  # Headless/server/VM hosts (no WM/DE) skip WM-dependent session variables.
  hasDesktop =
    (config.sysSettings.niri.enable or false)
    || (config.sysSettings.hyprland.enable or false)
    || (config.sysSettings.gnome.enable or false)
    || (config.sysSettings.cinnamon.enable or false)
    || (config.sysSettings.cosmic.enable or false);
in
{
  options = {
    sysSettings.boot = {
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
    };

    # Always-on base package groups. Each defaults to true so existing hosts are
    # unaffected; minimal hosts can opt out to keep the system/download small.
    sysSettings.base = {
      coreTools = lib.mkEnableOption "editor + nh + git core CLI tools";
      netArchives = lib.mkEnableOption "wget/curl/zip/rar/rsync archive+net tools";
      fsTools = lib.mkEnableOption "psmisc/pciutils/usbutils/killall/ntfs3g fs tools";
      imaging = lib.mkEnableOption "image/video codec + thumbnail support stack";
    };
  };

  config = {

    time.timeZone = "America/New_York";

    # Use zsh
    # NOTE: at a point i ran into a weird zsh error, run this if commands dont work
    #export PATH=/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$HOME/.local/bin:$PATH
    programs.zsh.enable = true;
    environment.shells = with pkgs; [ zsh ];
    users.defaultUserShell = pkgs.zsh; # default shell for new users

    # ==================================Tweaks========================================
    # inside here will be things that might need to find a home
    programs.dconf.enable = true; # key/value preference storage (GCONF successor)
    services.gnome.gnome-keyring.enable = true; # desktop password/keyring storage
    programs.evince.enable = true; # PDF thumbnailing
    services.tumbler.enable = true; # image/video thumbnail service

    # [perf / cleanliness]
    services.dbus.implementation = "broker"; # faster, lighter D-Bus than the reference implementation
    services.speechd.enable = lib.mkForce false; # text-to-speech daemon (off)

    # WM/DE-dependent session variables. Skipped on headless/server/VM hosts.
    environment.sessionVariables = lib.optionalAttrs hasDesktop {
      NIXOS_OZONE_WL = "1"; # nudges Electron/Chrome apps to use Wayland
      QT_QPA_PLATFORMTHEME = "qtct";
      QT_QPA_PLATFORMTHEME_QT6 = "qtct";
    };

    # tell NixOS to include these in the generated pixbuf loaders cache
    programs.gdk-pixbuf.modulePackages = lib.mkIf base.imaging (
      with pkgs;
      [
        librsvg
        webp-pixbuf-loader
      ]
    );

    # ==================================Boot========================================
    boot = {
      initrd.systemd.enable = true; # systemd in the initrd
      loader.timeout = lib.mkIf cfg.fastMenu 1; # 1s when fastMenu, else systemd-boot default (5s)
      consoleLogLevel = lib.mkIf cfg.quiet 3; # quieter kernel log
      kernelParams = lib.mkIf cfg.quiet [
        "quiet"
        "udev.log_level=3"
        "systemd.show_status=auto"
      ]; # end of kernelParams
    }; # end of boot

    # ==================================System Packages========================================
    # List packages installed in system profile.
    # use https://search.nixos.org/ to find more packages (and options).
    environment.systemPackages = lib.mkMerge [
      # [base]
      (lib.mkIf base.coreTools (
        with pkgs;
        [
          neovim # extensible terminal editor
          vim # classic terminal editor
          nh # nix helper (builds/deploys this config)
          git # version control
        ]
      ))

      # [Archives & net serv]
      (lib.mkIf base.netArchives (
        with pkgs;
        [
          wget # file retrieval over HTTP/HTTPS/FTP
          curl # URL-transfer CLI
          zip # zip archiver
          unzip # zip extractor
          rar # rar archiver
          rsync # incremental file transfer
        ]
      ))

      # [tools & file system]
      (lib.mkIf base.fsTools (
        with pkgs;
        [
          psmisc # killall + fuser
          pciutils # lspci
          usbutils # lsusb
          killall # kill by name
          ntfs3g # read/write NTFS
        ]
      ))

      # [image format support]
      (lib.mkIf base.imaging (
        with pkgs;
        [
          webp-pixbuf-loader # webp support for GTK apps
          libheif # heif/avif support
          libjxl # jpeg-xl support
          poppler-utils # PDF utilities
          poppler # PDF rendering lib
          ffmpegthumbnailer # video + image thumbnails
          gdk-pixbuf # image loading/manipulation lib
          librsvg # svg support + pixbuf loader rebuild
          libjpeg # jpeg support
          libpng # png support
          libtiff # tiff support
        ]
      ))
    ]; # end of environment.systemPackages
  }; # end of config
}
