# pull desktop, for ./ui-bin/default.nix
{ pkgs, desktop, ... }:
{
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

  # basic stats
  home.username = "jar";
  home.homeDirectory = "/home/jar";
  home.stateVersion = "25.11";

  # Font enable
  fonts.fontconfig.enable = true;

  # ==========================User pkgs in Home=============================
  # My PACKAGES, How epic, just be sure to add pkgs. before each package name <3
  # Note, check home-jar/app-bin/ for apps, there might be some that arnt showing up here
  home.packages = with pkgs; [
		# ====APPs====
    #
    # Browsers
		firefox
    librewolf # prefered browser

		mpv # for video playback

    # File Explorers
		nautilus # gnome' file manager
    ranger # tui file explorer

    # App[Stores]
		gnome-software # a good appstore
    bazaar # another good app store
		
    # APPs[Folding]
    # Text Editors
    vscodium # editor
    zed-editor # good text editor
    qownnotes # markdown app editor
    obsidian # non-opensourse notetaking app
    libreoffice # documents writer
    # Creation
    blender
		gnome-usage # resource monitor
    # Video APPs
    obs-studio # good video software

    # APPs[Entertainment]
    # Gaming
    steam # for gaming
    heroic # gaming
    # Chat
    discord # coms
    # Media
    blanket # background noises
    lollypop # music player[might change]

    # Unsorteds
		cowsay
		lazygit # for kool github viewing
		polkit_gnome # for a weird thing for some flatpak thing
		gh # for github login
		pavucontrol # audio control
    nwg-look  # The best tool for Wayland/Niri GTK styling if it is needed		
  ];  
}
