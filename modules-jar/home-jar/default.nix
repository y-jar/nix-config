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
		# APPs
		firefox
		mpv # for video playback
		kdePackages.dolphin # gui file manager if i need it.
		ranger # tui file explorer
		nautilus # gnome' file manager
		kdePackages.kate # kde's file editor
		gnome-software # the app store to solve my woes surrounding flatpaks
		vscodium # editor
		obs-studio # good video software
		gnome-usage # resource monitor
		gnome-boxes # VM manager i like

		# TUIs / TOOLS
		cowsay
		lazygit # for kool github viewing
		polkit_gnome # for a weird thing for some flatpak thing
		gh # for github login
		pavucontrol # audio control

		# FOR NIRI
		waybar # the bar
		mako # ?
		gnome-keyring
		xdg-desktop-portal-gtk
		xdg-desktop-portal-gnome
		fuzzel # app launcher
		kdePackages.polkit-kde-agent-1
		xwayland-satellite
		alacritty
		wl-clipboard # good cliboard manager
		xdg-utils   # opening links and such
  ];

  # APP LAUNCHER
  
}
