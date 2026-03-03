{ pkgs, lib, config, ... }:

let
  # Define a variable for the wallpaper so it's easy to change
  wallpaper = "/home/jar/pic-jar/wall-bin/halftone-laying-warrior.png";
in {
  # imports the sway-waybar so it doesnt have conflicts
  imports = [
  	./sway-bin/sway-waybar.nix # Epic waybar for sway.
  ];

  # If wayland.windowManager.sway.enable is false, none of this happens.
  wayland.windowManager.sway = {
    enable = true; 
    
    # Add the specific packages Sway needs HERE, not in main default.nix
    # This ensures they only exist when Sway is active WM
    systemd.enable = true; # Helps with cleaner startup/shutdown
    
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
        "Mod4+1" = "workspace number 1";
      };

      # ======================= Visuals ===========================
      bars = [ { command = "${pkgs.waybar}/bin/waybar"; } ];
      
      window = { border = 2; titlebar = false; };
      floating = { border = 2; titlebar = false; };

      # ====================== Start Up ===========================
      startup = [
        { command = "dbus-update-activation-environment --systemd --all"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        { command = "${pkgs.swww}/bin/swww-daemon"; }
        { command = "sleep 1 && ${pkgs.swww}/bin/swww img ${wallpaper}"; }
        { command = "swaymsg workspace number 1"; } # sets the def workspace
      ];
    };

    # Nice settings but idk the var names
    extraConfig = ''
      hide_edge_borders smart
    '';
  };

  # Use this block to tell Nix: "If Sway is enabled, also install these"
  config = lib.mkIf config.wayland.windowManager.sway.enable {
    home.packages = with pkgs; [
      wofi	     # App Launcher
      swww	     # Wallpaper manager
      swaynag-waiter # Better version of swaynag
      grim           # Screenshots (Sway specific tools)
      slurp	     # Drag Screenshots
    ];
  };
}
