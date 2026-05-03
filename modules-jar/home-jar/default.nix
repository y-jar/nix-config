# pull desktop, for ./ui-bin/default.nix
{ pkgs, desktop, ... }:
{
  #============================Imports================================
  imports = [
    # The other configs (Will need to set up other Default.nixs for easir useage)
    # UI pull NOTE: needs the desktop arg
    ./ui-jar/default.nix

    # Shell
    ./zsh.nix

    # APP CONFIGS
    ./app-bin/default.nix

    # GIT SETTINGS
    ./git.nix # for github shitt
  ];

  #===============================Base Setup================================
  # basic stats
  home.username = "jar";
  home.homeDirectory = "/home/jar";
  home.stateVersion = "25.11";

  # Font enable
  fonts.fontconfig.enable = true;

  # ==========================User Packages=============================
  # My PACKAGES, How epic, just be sure to add pkgs. before each package name <3
  # Note, check home-jar/app-bin/ for apps, there might be some that arnt showing up here
  home.packages = with pkgs; [
		# ====APPs====

    # [Browsers]
		firefox
    librewolf # prefered browser

    # [File Explorers]
		nautilus # gnome' file manager
    ranger # tui file explorer

    # [Appstores]
		gnome-software # a good appstore
    bazaar # another good app store
		
    # [Folding]
    # -[Text Editors]
    vscodium # editor
    zed-editor # good text editor
    qownnotes # markdown app editor
    libreoffice # documents writer
    # -[Video Oriented]
    obs-studio # good video software
    kdePackages.kdenlive

    # [Entertainment]
    # -[Gaming](done through flatpack mostly)
    #heroic
    steam
    #prismlauncher
    protonplus
    # -[Chat](done through flatpack mostly)
    #discord
    # -[Media](done through flatpack mostly)
    mpv # for video playback
    blanket # Background noises

    # ====Unsorteds====
		cowsay
		lazygit # for kool github viewing
		polkit_gnome # for a weird thing for some flatpak thing
		gh # for github login
		pavucontrol # audio control
    nwg-look  # The best tool for Wayland/Niri GTK styling if it is needed		
    gnome-usage # resource monitor
  ];  
}
