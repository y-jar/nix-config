{ pkgs, lib, ... }:
{
  # User-specific Sway settings (keybinds, etc) can go here later
  wayland.windowManager.sway = {
    enable = true;
    config = {
    	# ========================Vars============================
    	modifier = "Mod4"; # sets the super key as mod
	terminal = "foot"; # sets the def terminal
	menu = "wofi --show drun"; # app launcher

	# =================================Keybindings========================================
	# basic keybinds so i dont cry
	keybindings = lib.mkOptionDefault {
		"Mod4+d" = "exec wofi --show drun"; # starts the app launcher
		"Mod4+Return" = "exec foot"; # opens terminal
		"Mod4+Shift+q" = "kill"; # kills focused window
		"Mod4+Shift+e" = "exec swaynag -t warning -m 'Exit Sway?' -b 'Yes' 'swaymsg exit'"; # exits sway
	};

	
	# =================================Visuals============================================

	# Menu Bar
	bars = [
		{ command = "waybar";}
	];
	
	# Window
	window = {
		# vars
		border = 2;
		titlebar = false;
	};

	# floating stuff (like popups)
	floating = {
		# vars
		border = 2;
		titlebar = false;
	};

	

	# ==================================Start Up========================================
	# on sway startup
        startup = [
		
		# THIS Section is noted as not known, i tried to get bazaar to work, now i use gnome app store this might be useless, but we'll see
		# THE CRITICAL: This lets Bazaar and Polkit talk to each other
		{ command = "dbus-update-activation-environment --systemd --all"; }
		# the Polkit Agent
		{ command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
	]; #eo _S
    }; #eo _C

    # Direct Config:
    extraConfig = ''
    hide_edge_borders smart
    '';
  };
}
