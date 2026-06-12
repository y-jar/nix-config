{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.sysSettings.portal;
  efg = config.sysSettings;
in
{
  options = {
    sysSettings.portal = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      }; # end of enable option
    }; # end of portal options
  }; # end of options

  config = lib.mkIf cfg.enable {
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
        # inline if statements incase the DE/WM is not enabled
        gnome.default =
          if efg.gnome.enable then
            [
              "gnome"
              "gtk"
            ]
          else
            [ "gtk" ]; # end of gnome.default

        # force niri to use wlr portal, somehow this fixes streaming on discord.
        niri.default = lib.mkForce (
          if efg.niri.enable then
            [
              "wlr"
              "gtk"
            ]
          else
            [ "gtk" ] # end of niri.default
        );

        hyprland.default =
          if efg.hyprland.enable then
            [
              "hyprland"
              "gtk"
            ]
          else
            [ "gtk" ]; # end of hyprland.default
        # base for all other DEs/WMs
        common.default = [ "gtk" ]; # end of common.default
      }; # end of config
    }; # end of xdg.portal
  }; # end of config
}
