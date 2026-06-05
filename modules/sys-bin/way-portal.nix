{ pkgs, lib, ... }:
{
  # x support
  programs.xwayland.enable = true;

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
      gnome.default = [ "gnome" ];
      #plasma.default = [ "kde" ];
      #sway.default = [ "wlr" "gtk" ];
      niri.default = lib.mkForce [
        "wlr"
        "gtk"
      ]; # weird...
      hyprland.default = [
        "wlr"
        "gtk"
      ];
      common.default = [ "gtk" ];
    };
  };
}
