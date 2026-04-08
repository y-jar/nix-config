{ pkgs, hostnm, desktop, ... }:

{
	services.displayManager.sddm.enable = true;
	services.displayManager.sddm.wayland.enable = true;

	# sets the wm /DE, if this dont work, expect a fun time #tty time :(
	services.displayManager.plasma6.enable = (desktop == "plasma");
	programs.niri.enable = (desktop == "niri");
	programs.sway.enable = (desktop == "sway");

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

	#===============================WM / DE Dependant apps=====================================
	environment.systemPackages = with pkgs; 
	if (desktop == "plasma") then [
		# KDE Specific Apps
		kdePackages.dolphin
		kdePackages.spectacle
		kdePackages.ark
		kdePackages.gwenview
		kdePackages.kcalc
		
		# Crucial for Plasma 6 to handle your custom fonts/icons
		kdePackages.qtstyleplugin-kvantum 
	] else if (desktop == "niri") then [
		fuzzel
		waybar
		swaybg
		xwayland-satellite # Useful for running X11 apps in Niri
	] else [];
}