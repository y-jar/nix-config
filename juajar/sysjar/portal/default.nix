# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: XDG desktop portal setup for file pickers.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.sysset.portal;
  efg = config.sysset;
in
{
  options = {
    sysset.portal = {
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
        pkgs.xdg-desktop-portal-cosmic # cosmic
      ];
      # wlr portal (niri/mango): 0.8.2's default chooser probes wmenu/wofi/
      # bemenu/fuzzel via the portal unit's PATH, which only gets coreutils etc.
      # (no user profile) so every probe 404s and discord screencast dies in the
      # picker stage. force a store-path fuzzel chooser instead. options:
      # - 0.8.2 only knows default/none/simple/dmenu - "custom" hard-fails.
      # - "-dmenu" is NOT a fuzzel flag (misparses as --match-color=enu and
      #   fuzzel exits with empty stdout -> portal logs "no output found"),
      #   so use the xdpw-default style "-d" + prompt.
      wlr.settings.screencast = {
        chooser_type = "dmenu";
        chooser_cmd = "${pkgs.fuzzel}/bin/fuzzel -d -l 10 --prompt 'Select a source to share:'";
      };

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

        cosmic.default =
          if efg.cosmic.enable then
            [
              "cosmic"
              "gtk"
            ]
          else
            [ "gtk" ]; # end of cosmic.default
        # base for all other DEs/WMs
        common.default = [ "gtk" ]; # end of common.default
      }; # end of config
    }; # end of xdg.portal
  }; # end of config
}
