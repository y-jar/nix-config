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
      # pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-wlr
    ];
    # Per session portals... should be checking this stuff?
    config = {
      gnome.default = [
        "gnome"
        "gtk"
      ];
      #plasma.default = [ "kde" ];
      niri.default = lib.mkForce [
        "wlr"
        "gtk"
      ]; # weird...
      hyprland.default = [
        "wlr"
        "gtk"
      ];
      #sway.default = [ "wlr" "gtk" ];
      common.default = [ "gtk" ];
    };
  };
}
