{ pkgs, ... }:

{
  # enable sway
  programs.sway = {
  	enable = true;
  	wrapperFeatures.gtk = true; # tells sway to run on wayland
  };

  # login screen (configure elsewhere)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # essentials for the packages above
  environment.systemPackages = [
    pkgs.waybar	# good status bar
    pkgs.wofi	# app launcher
    pkgs.wl-clipboard # good cliboard manager
    pkgs.xdg-utils   # opening links and such
    pkgs.pavucontrol # audio control
  ];
  
  # Wayland enviroment vars
  # forces apps to use wayland if otherwise
  environment.sessionVariables = {
  	NIXOS_OZONE_WL = "1";
  	XDG_CURRENT_DESKTOP = "sway";
  };

  # enable portal for apps in sandboxes
  xdg.portal = {
	  enable = true;
	  wlr.enable = true; # Specifically for wlroots-based managers like Sway
	  extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
	  config.common.default = "*";
  };

  #
}
