{ pkgs, hostnm, desktop, ... }:

{
	# sets the wm /DE, if this dont work, expect a fun time #tty time :(
	services.desktopManager.plasma6.enable = (desktop == "plasma");
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
		# System & Resources
    kdePackages.plasma-systemmonitor
    kdePackages.filelight
    kdePackages.kcalc

    # Management & Utils
    kdePackages.ark
    kdePackages.dolphin-plugins
    kdePackages.spectacle
    kdePackages.gwenview
    kdePackages.okular
		kdePackages.kate # kde's file editor

		
		# Crucial for Plasma 6 to handle custom fonts/icons
		kdePackages.qtstyleplugin-kvantum 
	] else if (desktop == "niri") then [
		swaybg
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
	] else [];
}