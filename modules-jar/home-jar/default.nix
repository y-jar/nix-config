# pull desktop, for ./ui-bin/default.nix
{ pkgs, desktop, ... }:
{
  imports = [
    # The other configs (Will need to set up other Default.nixs for easir useage)
    # UI pull NOTE: needs the desktop arg
    ./ui-jar/default.nix

    # Shell
    ./zsh.nix

    # App Module Paths
    ./foot.nix 		     # Pulls in terminal/font settings
    ./nvim.nix 		     # Pulls the nvim config (this is under heavy questioning)
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
  # Note, if commented out, it means they are managed elsewhere
  home.packages = [
	# General Apps
	pkgs.firefox
	pkgs.mpv # for video playback
	pkgs.kdePackages.dolphin # gui file manager if i need it.
	pkgs.gnome-software # the app store to solve my woes surrounding flatpaks

	# TUIs / tools in terminal 
	#pkgs.neovim
	pkgs.ranger
	pkgs.btop
	pkgs.cowsay
	pkgs.lazygit # for kool github viewing
	
	# Tools General
	#pkgs.grim # for general screenshots
	#pkgs.slurp # for that drag screenshot
	pkgs.polkit_gnome # for a weird thing for some flatpak thing
	pkgs.gh # for github login
	
	# Fonts / General Personal Visuals
	pkgs.fastfetch
	pkgs.nerd-fonts.intone-mono 
	#pkgs.swww

	# SHELL / DE makin'
	#pkgs.waybar	# good status bar
	#pkgs.wofi	# app launcher
	pkgs.wl-clipboard # good cliboard manager
	pkgs.xdg-utils   # opening links and such
	pkgs.pavucontrol # audio control
  ];
}
