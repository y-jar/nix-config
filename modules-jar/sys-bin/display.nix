{ pkgs, lib, hostnm, desktop, ... }:

{
	# sets the wm /DE, if this dont work, expect a fun time #tty time :(
	services.desktopManager.plasma6.enable = (desktop == "plasma");
	programs.niri.enable = (desktop == "niri");
	programs.sway.enable = (desktop == "sway");

	# tweeks
	programs.kdeconnect.enable = false; # rule out interference

	# Wayland enviroment vars
	# forces apps to use wayland if otherwise
	environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        XDG_CURRENT_DESKTOP = if (desktop == "plasma") then "KDE" 
                              else if (desktop == "niri") then "niri" 
                              else if (desktop == "sway") then "sway" 
                              else "wlroots";
    };

	# enable portal for apps in sandboxes
	xdg.portal = {
		enable = true;
		extraPortals = if (desktop == "plasma") 
					then [ pkgs.kdePackages.xdg-desktop-portal-kde ]
					else [ pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk ];
		config = lib.mkForce {
		common.default = [ "kde" ];
		kde = {
			default = [ "kde" ];
		};
		};
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
		kdePackages.sddm-kcm # to manage sddm

		
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