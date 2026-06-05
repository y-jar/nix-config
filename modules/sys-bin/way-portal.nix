{ pkgs, lib, ... }:
{
  # x support
  programs.xwayland.enable = true;

  # Wayland enviroment vars
  # forces apps to use wayland if otherwise
  # Wayland tweaks (global, good for all sessions)
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # nudges Electron/Chrome apps to use Wayland
  };

  # XDG portal: set new defaults for my DEs and WMs
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
    ];
    # Per session portals... should be checking this stuff?
    config = {
      gnome.default = [ "gnome" ];
      niri.default = [ "gnome" "gtk" ]; # weird... 
      hyprland.default = [
        "gtk"
      ];
      #sway.default = [ "wlr" "gtk" ];
      common.default = [ "gnome" ];
    };
  };
}
