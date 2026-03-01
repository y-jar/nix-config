{ pkgs, lib, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      # ======================== Vars ============================
      modifier = "Mod4"; 
      terminal = "${pkgs.foot}/bin/foot"; 
      menu = "${pkgs.wofi}/bin/wofi --show drun"; 

      # ===================== Keybindings =========================
      keybindings = lib.mkOptionDefault {
        "Mod4+d" = "exec ${pkgs.wofi}/bin/wofi --show drun";
        "Mod4+Return" = "exec ${pkgs.foot}/bin/foot";
        "Mod4+Shift+q" = "kill";
        "Mod4+Shift+e" = "exec swaynag -t warning -m 'Exit Sway?' -b 'Yes' 'swaymsg exit'";
        
        # Adding the Workspace 1 fix
        "Mod4+1" = "workspace number 1";
      };

      # ======================= Visuals ===========================
      bars = [
        { command = "${pkgs.waybar}/bin/waybar"; }
      ];
      
      window = {
        border = 2;
        titlebar = false;
      };

      floating = {
        border = 2;
        titlebar = false;
      };

      # ====================== Start Up ===========================
      startup = [
        { command = "dbus-update-activation-environment --systemd --all"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        
	# Start swww for yummy wall papers
	{ command = "${pkgs.swww}/bin/swww-daemon"; }
	{ command = "sleep 1 && ${pkgs.swww}/bin/swww img /home/jar/pic-jar/wall-bin/halftone-laying-warrior.png"; }

	# Force it to Workspace 1 on start
        { command = "swaymsg workspace number 1"; }
      ];
    };

    extraConfig = ''
      # This is raw Sway config syntax
      hide_edge_borders smart
    '';
  };
}
