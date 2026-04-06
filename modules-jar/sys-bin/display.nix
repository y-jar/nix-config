{ pkgs, hostnm, desktop, ... }:

{
	services.displayManager.sddm.enable = true;
	services.displayManager.sddm.wayland.enable = true;

	# sets the wm /DE, if this dont work, expect a fun time #tty time :(
	programs.${desktop}.enable = true;
	# Wayland enviroment vars
	# forces apps to use wayland if otherwise
	environment.sessionVariables = {
		NIXOS_OZONE_WL = "1";
		XDG_CURRENT_DESKTOP = "${hostnm}";
	};

	# enable portal for apps in sandboxes
	xdg.portal = {
		enable = true;
		wlr.enable = true; # Specifically for wlroots-based managers like Sway
		extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
		config.common.default = "*";
	};
}