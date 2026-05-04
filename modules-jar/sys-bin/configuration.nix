
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
   waypaper # use for setting wallpapers for WMs
   gnome-boxes # virtual mechines

  #  [theme/optional]
  catppuccin-sddm

   # [cl/tui tools]]
   wget
   fcitx5 # for typing in japanese?
   fcitx5-mozc # other japan language sturff
   curl
   git # virsion control
   jp # json parser
   zip
   unzip
   tree
   fastfetch
   btop
   fzf # fuzzy finder
   psmisc        # Provides killall
   pciutils      # Provides lspci
   usbutils      # Provides lsusb
   htop          # Better than top
   killall
   tldr
   fd # 
   rsync # file copying
   tmux # terminal multiplexer

   # [gaming]
   mangohud # for huds
   protonup-qt # installer for proton vers
   vulkan-tools # for gpu ensurence
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
  
  # STEAM DERIVED FIXES
  # Support for controllers
  hardware.xpadneo.enable = true; # for Xbox controllers
  services.udev.packages = [ pkgs.game-devices-udev-rules ];
  # It installs the 'udev rules' so controllers are recognized
  hardware.steam-hardware.enable = true;
  # graphics + 32bit support for Steam
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # libs
    extraPackages = with pkgs; [
      # [intel]
      intel-media-driver # iHD — Broadwell+ [my N100 on yilyonix]
      intel-vaapi-driver # i965 — older Intel fallback
      intel-compute-runtime # OpenCL for Intel [useful for Blender, Darktable etc]
      intel-ocl # older Intel OpenCL fallback

      # [amd]
      amdvlk # amd's official vulkan driver [alternative to radv in mesa]

      # [global / fallback]
      vaapiVdpau # VDPAU via VA-API bridge (helps Nvidia/AMD too)
      libvdpau-va-gl # VDPAU OpenGL fallback
      mesa # amd and intel open sourse drivers
      libva-utils # vainfo command. good for debugging VA-API
      libvdpau # base VDPAU library
      vulkan-loader # Vulkan ICD loader
      vulkan-tools # vulkaninfo etc, good for debugging
      vulkan-validation-layers # catches Vulkan errors, helpful for gaming

      # [codecs]
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav      # ffmpeg bridge for gstreamer
    ];
    # 32 bit libs for:
    # wine, proton, and any other compatability layer the reqs graphics 
    #   and 32 bit libs
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiIntel # 32bit Intel for Steam
      mesa # 32bit mesa for Steam/Wine/Proton
      vulkan-loader # Vulkan ICD loader
      libvdpau-va-gl # VDPAU OpenGL fallback
      vaapiVdpau # VDPAU via VA-API bridge (helps Nvidia/AMD too)
    ];
  };

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

