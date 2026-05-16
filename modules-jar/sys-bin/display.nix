{ pkgs, lib, hostnm, ... }:

{
  # DEs
  services.desktopManager.gnome.enable = true;
	#services.desktopManager.plasma6.enable = true;
  # WMs
	programs.niri.enable = true;
  programs.hyprland.enable = true;
	programs.sway.enable = true;

  # x support
  programs.xwayland.enable = true;

	# Wayland enviroment vars
	# forces apps to use wayland if otherwise
	# Wayland tweaks (global, good for all sessions)
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # nudges Electron/Chrome apps to use Wayland
  };

	# XDG portal — KDE's handles Plasma; gtk fallback covers other sessions
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = [ "kde" "gtk" ];
  };

	#===============================WM / DE Dependant apps=====================================
	# Plasma companion apps
  environment.systemPackages = with pkgs; [
		# [kde companion apps]
    kdePackages.plasma-systemmonitor
    kdePackages.filelight
    kdePackages.kcalc
    kdePackages.ark
    kdePackages.dolphin-plugins
    kdePackages.spectacle
    kdePackages.gwenview
    kdePackages.okular
    kdePackages.kate
    kdePackages.sddm-kcm # manage SDDM from within Plasma settings
    kdePackages.qtstyleplugin-kvantum
    kdePackages.plasma-keyboard
    kdePackages.plasma-thunderbolt
    kdePackages.plasma-activities-stats
    kdePackages.plasma-activities
    kdePackages.kdeplasma-addons
    kdePackages.bluedevil # Bluedevil adds Bluetooth capabilities to KDE Plasma

    # [gnome companion apps]
    gnome-software # a good appstore
    gnome-bluetooth # bluetooth
    gnome-characters # for inserting chars
    gnome-maps
    gnome-chess
    gnome-music
    gnome-panel
    gnome-shell # might not be needed, we'll see
    gnome-usage
    gnome-boxes # virtual mechines
    gnome-common
    gnome-tweaks
    gnome-desktop # Library with common API for various GNOME modules
    gnome-nettool # Collection of networking tools
    gnome-firmware # might not need, but who knows
    gnome-extension-manager
    gnome-disk-utility # for disk util


		# [niri reqs]
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

    # [hyprland companion apps]
    hyprshot # Utility to easily take screenshots in Hyprland using your mouse
    hyprlandPlugins.hyprscrolling # Hyprland scrolling layout plugin
    hyprlauncher # A multipurpose and versatile launcher / picker for Hyprland
    hyprlock # Hyprland's GPU-accelerated screen locking utility
    hyprsunset # Application to enable a blue-light filter on Hyprland
  ];

  # Misc tweaks
  programs.kdeconnect.enable = false; # flip to true when you want it
}