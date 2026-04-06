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

  # BOOTLOADER:
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

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

  #==============================USER & PKGS================================
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jar = {
    isNormalUser = true;
    description = "jar";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # apps
      kdePackages.kate
      bazaar
      steam
      librewolf
    ];
  };

  # MANUAL APPS:
  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # SYSTEM PKGS:
  # To search, run: "$ nix search wget"
  environment.systemPackages = with pkgs; [
     #

     # APPS
     vim
     neovim
     kitty # incase foot doesnt work for root
     vscodium

     # TOOLS
     wget
     curl
     git
     unzip
     tree
     fastfetch
     btop
     fzf

     # FONTS
     nerd-fonts.intone-mono
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
