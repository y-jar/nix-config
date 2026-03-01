{ pkgs, ... }:

{
	services.displayManager.sddm.enable = true;
	services.displayManager.sddm.wayland.enable = true;

	# perms or som shi, i broke the config at this time #tty :(
	programs.sway.enable = true;
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
}