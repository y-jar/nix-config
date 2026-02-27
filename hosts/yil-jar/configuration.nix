# Hi So this is my NixOS Configuration, this took a while to figure out and i always go 
# overboard when it comes to trying new things so this is it.
# 
# I made this to serve as my main OS to use, but as of writing this, i am in bed coding on an 
# Ideapad 3i with an n100 chip with 4 gigs of ram, so lets just say i kepted this barebones
# when it comes to the wacky features, but hopefully i will fleash it out more so i can do some
# real gamin'.
# 
# Any real issues that might arise might be with some weird settings i set not knowing whatever
# they do in the first place. So feel free to add notes or critizism!


# Documentation key of the os, and comments are as follows:
#
# In-file formatting:
# -page split/deviders (whatever type), must contain a ending 2 newlines for readablility
# -sections of code must be orgainised to prevent duplicite data or declairations or just messes
# -In-line comments are optinal but recommended to use on spots that i don't know :)
# -When making a block that does alot, do list basic core features of the function to let users 
#   easily follow the flow of the config.


{ config, lib, pkgs, ... }:

{
  # ===========================================Nix In A Jar=================================================
  # imports other modules like:
  # -the hardware configuration for support
  # -desktop module for adding a baseline for UX (currently sway and wayland)
  # -Other nodes where it is important to take mesures to seperate(flatpaks)
  #  NOTE on flatpak-manager.nix, after rebuild switching, be sure to reboot. 
  #  		Then you can run a command like ```flatpak install flathub bazaar```
  imports =
    [ 
      # Include the hardware config duh.
      ./hardware-config.nix
      # ./modules like display and window manager and such
      ../../modules/desktop/desktop.nix

      # Other Nodes
      ./flatpak-manager.nix # To manage flatpaks (they hurt my brain)
      ./v412loopback.nix    # helps with virtual cameras like in OBS
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

   
  # =======================================USERS===============================================
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jar = {
   isNormalUser = true;
   shell = pkgs.zsh; # makes user explicitly use zsh
   extraGroups = [ "wheel" "video" "input" "networkmanager" ]; # Enable ‘sudo’ for the user.
  }; # note for pkgs we do that within the home.nix now for more general stuff


  # ========================================Networking/presentaion================================================
  # Networking hostname, (this also is just the hostname of the system)
  networking.hostName = "yil-jar"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true; # enables the network manager, this can also elsewhere.
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ]; # had some dns issues, manually set the connection to google and cloudflare

  # Set the time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # ==================================Packages :)========================================
  # List packages installed in system profile.
  # use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
   # here is were i put my basic packages for the base system :3
   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   wget
   curl
   git
   unzip
   tree
  ];


  # ==================List services=========================
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR just use this for additinal settings
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # NOTE: at a point i ran into a weird zsh error, run this if commands dont work
  #export PATH=/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$HOME/.local/bin:$PATH 
  programs.zsh.enable = true;

  # Enables nix-ld to run unpatched binaries (like in my neovim config)
  # acts as a compatability thing, if this has an issue, or i dont like it, SHUT OFF HEHEHE
  programs.nix-ld.enable = true;

  # Add this to your main configuration file
  programs.dconf.enable = true; 
  services.gnome.gnome-keyring.enable = true; # Helps store passwords/settings


  # ==================================================================================
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

