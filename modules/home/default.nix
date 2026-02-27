{ pkgs, ... }:
{
  imports = [
    # The other configs (Will need to set up other Default.nixs for easir useage)
    ../desktop/sway.nix      # Pulls in your Sway config
    ./shell/zsh.nix		     # Pulls my zsh config
    # App Module Paths
    ./apps/foot.nix 		     # Pulls in terminal/font settings
    ./apps/nvim.nix 		     # Pulls the nvim config (this is under heavy questioning)
    ./git-user.nix # for github shitt
  ];

  home.username = "jar";
  home.homeDirectory = "/home/jar";
  
  # Font enable
  fonts.fontconfig.enable = true;
  # My PACKAGES, How epic, just be sure to add pkgs. before each package name <3
  # Note, if commented out, it means they are managed elsewhere
  home.packages = [
	# General Apps
	pkgs.firefox
	pkgs.mpv # for video playback
	pkgs.kdePackages.dolphin # gui file manager if i need it.
	pkgs.gnome-software # the app store to solve my woes
		

	# TUIs / tools in terminal 
	#pkgs.neovim
	pkgs.ranger
	pkgs.btop
	
	# Tools General
	pkgs.grim # for general screenshots
	pkgs.slurp # for that drag screenshot
	pkgs.polkit_gnome # for a weird thing for some flatpak thing
	pkgs.gh # for github login
	
	# Fonts / General Personal Visuals
	pkgs.fastfetch
	pkgs.nerd-fonts.intone-mono 
  ];

  home.stateVersion = "25.11";
}
