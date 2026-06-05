{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # [monitor setup]
      monitor = ",preferred,auto,1";

      # [autostart]
      exec-once = [
        "noctalia-shell"
      ];

      # [input]
      input = {
        # kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
      };

      # [look and feel]
      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 0;
        "col.active_border" = "rgba(88c0d0ff)";
        "col.inactive_border" = "rgba(444444ff)";
      };
      decoration = {
        rounding = 2;
        blur.enabled = true;
      };

      # [keybinds <3]
      "$mod" = "SUPER";
      bind = [
        # [Core]
        "$mod, Return, exec, foot"
        "$mod, Q, killactive"
        "$mod, Space, exec, fuzzel"
        "$mod, F, fullscreen"
        # [moving focus]
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"
        # [workspaces]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        # [move window to workspace]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
      ];

      # systemd varibles
      systemd.variables = [ "--all" ];
    };
  };
}
