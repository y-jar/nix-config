{
  pkgs,
  ...
}:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # =======================================NIXOS=================================================

  # ==================================System Packages========================================
  # List packages installed in system profile.
  # use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    # [base]
    vim # text editor
    neovim # text editor
    yazi # file manager
    comma # run bianaries
    nh # nix helper

    # [apps]
    kitty # incase foot doesnt work for root
    keepassxc # [passwordmgr]
    waypaper # use for setting wallpapers for WMs

    #  [theme/optional]
    catppuccin-sddm

    # [cl/tui tools / resources]]
    tldr # Simplified and community-driven man pages
    bat # Cat(1) clone with syntax highlighting and Git integration
    wget
    curl
    git # virsion control
    jp # json parser
    zip
    unzip
    tree
    fastfetch
    btop
    fzf # fuzzy finder
    psmisc # Provides killall
    pciutils # Provides lspci
    usbutils # Provides lsusb
    htop # Better than top
    killall
    fd
    rsync # file copying
    tmux # terminal multiplexer [fuck.. i never used this]
    wine # we all know what this is
    ntfs3g # for my woes with ntfs
    subversion # Version control system intended to be a compelling replacement for CVS in the open source community
    rar # Utility for RAR archives

    # [gaming]
    mangohud # for huds
    protonup-qt # installer for proton vers
    #proton-tricks # aperently gone?

    # [image format support]
    webp-pixbuf-loader # webp support for GTK apps including GNOME
    libheif # heif/avif support
    libjxl # jpeg-xl support
    evince # PDF viewer + thumbnailer
    poppler-utils # PDF rendering lib
    poppler
    ffmpegthumbnailer # video + image thumbnails
    gdk-pixbuf # Library for image loading and manipulation
    librsvg # svg support + triggers full pixbuf loader cache rebuild
    libjpeg # jpeg support
    libpng # png support (usually present but explicit is safer)
    libtiff # tiff support
  ];

  # tell NixOS to include these in the generated pixbuf loaders cache
  programs.gdk-pixbuf.modulePackages = with pkgs; [
    librsvg
    webp-pixbuf-loader
  ];
}
