{ pkgs, lib, ... }:
{
  # x support
  programs.xwayland.enable = true;

  # XDG portal: set new defaults for my DEs and WMs
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr # niri
      pkgs.xdg-desktop-portal-hyprland # hyprland
      pkgs.xdg-desktop-portal-gnome # gnome
      pkgs.xdg-desktop-portal-gtk # fallback file pickers
    ];
    config = {
      gnome.default = [
        "gnome"
        "gtk"
      ];
      niri.default = [
        "gnome"
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
