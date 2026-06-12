{ pkgs, lib, ... }:
{
  # x support
  programs.xwayland.enable = true;

  # XDG portal: set new defaults for my DEs and WMs
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk # fallback file pickers
      pkgs.xdg-desktop-portal-gnome # gnome
      pkgs.xdg-desktop-portal-wlr # niri
      pkgs.xdg-desktop-portal-hyprland # hyprland
    ];
    config = {
      gnome.default = [
        "gnome"
        "gtk"
      ];
      niri.default = lib.mkForce [
        "wlr"
        "gtk"
      ];
      hyprland.default = [
        "hyprland"
        "gtk"
      ];
      common.default = [ "gtk" ];
    }; # end of config
  }; # end of xdg.portal
}
