# THIS IS A OPTINAL ROUTE:
# this is meant for me if i dont want to use the larger config 

#==============================================================

{ config, pkgs, ... }:

{
  #============================BASIC STARTING INFO==================================
  # IMPORTS:
  imports =
    [
      # HARDWARE
      ./hardware-configuration.nix
    ];

  # BOOTLOADER Use what is generated:
  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/vda";
  # boot.loader.grub.useOSProber = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  #==============================DISPLAY / UX================================

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # enable portal for apps in sandboxes
	xdg.portal = {
		enable = true;
		wlr.enable = true; # Specifically for wlroots-based managers like Sway
		extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
		config.common.default = "*";
	};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  #=============================SOUND=================================
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #==============================USER.PKGS================================
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jar = {
    isNormalUser = true;
    description = "jar";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # ====APPs====

      # ==[Browsers]
      firefox
      librewolf # prefered browser

      # ==[File Explorers]
      nautilus # gnome' file manager
      ranger # tui file explorer
      xfce.thunar # Xfce file manager

      # ==[app related]
      bazaar # flatpack app store [software center is in display.nix]
      gearlever # manages app images
      
      # ==[Folding]
      # -[Text Editors]
      vscodium # editor
      zed-editor # good text editor
      qownnotes # markdown app editor
      libreoffice # documents writer
      onlyoffice-desktopeditors # Office suite that combines text, spreadsheet and presentation editors allowing to create, view and edit local documents
      buffer # Minimal editing space for all those things that don't need keeping

      # ==[graphics]
      obs-studio # good video software
      kdePackages.kdenlive # video editor
      halftone # Simple app for giving images that pixel-art style
      krita # Free and open source painting application
      converseen # Batch image converter and resizer
      fontforge # Font editor
      coulr # Color box to help developers and designers
      # [Other Folds]
      mediawriter # Tool to write images files to portable media
      # [audio]
      easyeffects # audio mixer
      qpwgraph # Qt graph manager for PipeWire, similar to QjackCtls
      
      # ==[Entertainment]
      # -[Gaming]
      # stuff like! heroic, steam, prismlauncher WOW how awesome me, such a gaymer
      protonplus # manager and installer for proton versions
      protontricks # adds tricks for proton for additional preformance [right now it doesnt work...]
      steam # gaming app
      #prismlauncher
      # -[Media]
      blanket # Background noises
      quodlibet # media player
      mpv # for video playback
      
      # ==[My Cursors! / Icons! / +!]
      nwg-look  # The best tool for Wayland/Niri GTK styling if it is needed		
      #[cursors]
      bibata-cursors # clean material-style, very popular
      bibata-cursors-translucent # Translucent Varient of the Material Based Cursor
      catppuccin-cursors # matches catppuccin theme
      phinger-cursors # fun colorful ones
      #[Icons]
      catppuccin-papirus-folders # papirus but with catppuccin colored folders
      adwaita-icon-theme # gnome default, good fallback
      numix-icon-theme-circle # circular icons

      # ==[keyboard / language]
      fcitx5 # for typing in japanese?
      fcitx5-mozc # other japan language sturff


      # ====Unsorteds====
      lmstudio # for those who want to use AI
      bottles # Easy-to-use wineprefix manager
      waydroid # Container-based approach to boot a full Android system on a regular GNU/Linux system
      cowsay
      lazygit # for kool github viewing
      polkit_gnome # for a weird thing for some flatpak thing
      gh # for github login
      discord # game social app [Will be depricated!]
    ];
  };

  # MANUAL APPS:
  # Install firefox.
  programs.firefox.enable = true;

  # ================================TWEAKS.EXTRA=================================
  # For Steam
  # STEAM FIX: This is the important part!
  # It installs the 'udev rules' so controllers are recognized
  hardware.steam-hardware.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  


  #==============================SYS.PKGS====================================
  # To search, run: "$ nix search wget"
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
    pavucontrol

    #  [theme/optional]
    catppuccin-sddm
    # [gnome-extentions]
    gnomeExtensions.places-status-indicator # little thing for the top left that holds the jumper for the favorited dirs
    gnomeExtensions.blur-my-shell # Adds a blur look to different parts of the GNOME Shell, including the top panel, dash and overview.
    gnomeExtensions.vitals # A glimpse into your computer's temperature, voltage, fan speed, memory usage, processor load, system resources, network speed and storage stats. This is a one stop shop to monitor all of your vital sensors. Uses asynchronous polling to provide a smooth user experience. Feature requests or bugs? Please use GitHub.

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
    fd # 
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

  # This holds FONTS
  fonts.packages = with pkgs; [
    # ADD FONTS HERE, then add Return Name After 
    # [ltn]
    nerd-fonts.intone-mono # RN: IntoneMono Nerd Font
    comfortaa # Clean and modern font suitable for headings and logos
    cascadia-code # Monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal

    # [jp]
    ipaexfont # japanese font
    rounded-mgenplus # Japanese font based on Rounded M+ and Noto Sans Japanese
    koruri # Japanese TrueType font obtained by mixing M+ FONTS and Open Sans
    #nerd-fonts.m+ # Nerd Fonts: Multiple styles and weights, many glyph sets (e.g. Kana glyphs)
  ];

  #============================NETWORKING==================================
  # This is where you would configutr my networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    
    # for dns issues i keep running into
    nameservers = [ 
    	"8.8.8.8" # google
	    "1.1.1.1" # Coudflare
    ]; 

    # Configure network proxy if necessary
    #proxy.default = "http://user:password@proxy:port/";
    #proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # firewall shii
    firewall = {
      enable = true;
      allowedTCPPorts = [ 53317 ]; # LocalSend
      allowedUDPPorts = [ 53317 5353 ]; # LocalSend + mDNS
      
      # For KDE Connect / Phone integration Un comment if needed
      allowedTCPPortRanges = [ { from = 53317; to = 53320; } ];
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
    };
  };

  # for the dynamic seaching that other distros use.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  #============================OTHERS TO BE SORTED==================================
  system.stateVersion = "25.11";

}
