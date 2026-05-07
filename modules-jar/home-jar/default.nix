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
    xfce.thunar # Xfce file manager

    # [Appstores]
    bazaar # flatpack app store [software center is in display.nix]
		
    # [Folding]
    # -[Text Editors]
    vscodium # editor
    zed-editor # good text editor
    qownnotes # markdown app editor
    libreoffice # documents writer
    # [graphics]
    obs-studio # good video software
    kdePackages.kdenlive # video editor
    halftone # Simple app for giving images that pixel-art style
    krita # Free and open source painting application
    # [audio]
    easyeffects # audio mixer
    qpwgraph # Qt graph manager for PipeWire, similar to QjackCtls

    # [Entertainment]
    # -[Gaming]
    #heroic
    #steam
    #prismlauncher
    protonplus # manager and installer for proton versions
    # -[Media]
    mpv # for video playback
    blanket # Background noises
    quodlibet # media player

    # ====Unsorteds====
    lmstudio # for those who want to use AI
		cowsay
		lazygit # for kool github viewing
		polkit_gnome # for a weird thing for some flatpak thing
		gh # for github login
		pavucontrol # audio control
    nwg-look  # The best tool for Wayland/Niri GTK styling if it is needed		
    gnome-usage # resource monitor
  ];  
}
