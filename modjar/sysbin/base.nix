{ pkgs, ... }:
{
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
    programs.dconf.enable = true; # dconf is a simple key/value storage system that is heavily optimised for reading. This makes it an ideal system for storing user preferences (which are often read but rarely changed). It was created with this use case in mind.
    services.gnome.gnome-keyring.enable = true; # Helps store passwords/settings
    programs.evince.enable = true; # Enablilng this native option automatically sets up PDF thumbnailing
    services.tumbler.enable = true; # image stuff

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1"; # nudges Electron/Chrome apps to use Wayland
      QT_QPA_PLATFORMTHEME = "qtct";
      QT_QPA_PLATFORMTHEME_QT6 = "qtct";
    };

    # tell NixOS to include these in the generated pixbuf loaders cache
    programs.gdk-pixbuf.modulePackages = with pkgs; [
      librsvg
      webp-pixbuf-loader
    ];

    # ==================================System Packages========================================
    # List packages installed in system profile.
    # use https://search.nixos.org/ to find more packages (and options).
    environment.systemPackages = with pkgs; [
      # [base]
      neovim # Vim text editor fork focused on extensibility and agility
      vim # text editor
      nh # nix helper
      comma # Runs programs without installing them
      git # version control

      # [Archives & net serv]
      wget # Tool for retrieving files using HTTP, HTTPS, and FTP
      curl # Command line tool for transferring files with URL syntax
      zip # Compressor/archiver for creating and modifying zipfiles
      unzip # Extraction utility for archives compressed in .zip format
      rar # Utility for RAR archives
      rsync # Fast incremental file transfer utility

      # [tools & file system]
      psmisc # Provides killall
      pciutils # Provides lspci
      usbutils # Provides lsusb
      killall # with attribute killall ? Environments:
      ntfs3g # for my woes with ntfs

      # [image format support]
      webp-pixbuf-loader # webp support for GTK apps including GNOME
      libheif # heif/avif support
      libjxl # jpeg-xl support
      poppler-utils # PDF rendering lib
      poppler
      ffmpegthumbnailer # video + image thumbnails
      gdk-pixbuf # Library for image loading and manipulation
      librsvg # svg support + triggers full pixbuf loader cache rebuild
      libjpeg # jpeg support
      libpng # png support (usually present but explicit is safer)
      libtiff # tiff support

      # [Other to be sorted]
      # [Niri / Wayland Environment Essentials]
      swaybg # Wallpaper tool for Wayland compositors
      waybar # Highly customizable Wayland bar for Sway and Wlroots based compositors
      fuzzel # Wayland-native application launcher, similar to rofi’s drun mode
      xwayland-satellite # Xwayland outside your Wayland compositor
      wl-clipboard # Command-line copy/paste utilities for Wayland
      xdg-utils # xdg-utils

      # php # HTML-embedded scripting language
      # mariadb # Enhanced, drop-in replacement for MySQL
    ]; # end of environment.systemPackages
  }; # end of config
}
