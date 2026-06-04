{
  pkgs,
  ...
}:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # =======================================enabled pkgs=================================================
  programs.steam.enable = true;
  # tell NixOS to include these in the generated pixbuf loaders cache

  # ==================================System Packages========================================
  # List packages installed in system profile.
  # use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    # [base]
    vim # text editor
    nh # nix helper

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
  ];
}
