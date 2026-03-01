
{ config, lib, pkgs, ... }:

{
  # ===========================================Nix In A Jar=================================================
  

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set what timeZone you want
  time.timeZone = "America/New_York";

   
  # =======================================USERS===============================================
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jar = {
   isNormalUser = true;
   shell = pkgs.zsh; # makes user explicitly use zsh
   extraGroups = [ "wheel" "video" "input" "networkmanager" ]; # Enable ‘sudo’ for the user.
  }; # note for pkgs we do that within the home.nix now for more general stuff



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

  programs.dconf.enable = true; 
  services.gnome.gnome-keyring.enable = true; # Helps store passwords/settings


  # ==================================================================================
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

