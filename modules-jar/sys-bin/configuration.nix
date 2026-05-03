
{ config, lib, pkgs, ... }:

{
  # =======================================NIXOS=================================================
  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # Set what timeZone you want
  time.timeZone = "America/New_York";

  # NOTE: at a point i ran into a weird zsh error, run this if commands dont work
  #export PATH=/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$HOME/.local/bin:$PATH 
  programs.zsh.enable = true;
   
  # =======================================USERS===============================================
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jar = {
  #           ^^^-[Ensure this is the username of the system, this is  ]
  #               [  also used in other areas like home-jar/default.nix]
   isNormalUser = true;
   shell = pkgs.zsh; # makes user explicitly use zsh
   # add groups:
   extraGroups = [ "wheel" "video" "input" "networkmanager" "libvirtd" ];
  }; # note for pkgs we do that within the nix-config/modules-jar/home-jar/default.nix now


  # ==================================System Packages========================================
  # List packages installed in system profile.
  # use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
   # [base]
   vim # text editor
   neovim # text editor

   # [apps]
   kitty # incase foot doesnt work for root
   keepassxc # [passwordmgr]
   lmstudio # for those who want to use AI

  #  [theme/optional]
  catppuccin-sddm
  waypaper # use for setting wallpapers for WMs

   # [cl/tui tools]]
   wget
   fcitx5 # for typing in japanese?
   fcitx5-mozc # other japan language sturff
   curl
   git
   unzip
   tree
   fastfetch
   btop
   fzf
   psmisc        # Provides killall
   pciutils      # Provides lspci (great for checking that 6700XT)
   usbutils      # Provides lsusb
   htop          # Better than top
   killall
   tldr
   fd # 

   # [gaming]
   mangohud # for huds
   protonup-qt # installer for proton vers
   vulkan-tools # for gpu ensurence

   # [Virtual Mechines]
   gnome-boxes
  ];


  # ==================List services=========================
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enables nix-ld to run unpatched binaries (like in my neovim config)
  # acts as a compatability thing, if this has an issue, or i dont like it, SHUT OFF HEHEHE
  programs.nix-ld.enable = true;

  programs.dconf.enable = true; 
  services.gnome.gnome-keyring.enable = true; # Helps store passwords/settings


  #===============================Gaming Fixes / tweeks========================================
  
  # Support for controllers
  hardware.xpadneo.enable = true; # for Xbox controllers
  services.udev.packages = [ pkgs.game-devices-udev-rules ];
  # It installs the 'udev rules' so controllers are recognized
  hardware.steam-hardware.enable = true;

  # Improve performance by allowing games to request CPU priority
  security.rtkit.enable = true;


  # =====================================Other=============================================
  

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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

