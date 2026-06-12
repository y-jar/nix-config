{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.theming;
in
{
  config = lib.mkIf cfg.enable {
    # gtk settings
    gtk = {
      enable = true;
      colorScheme = "dark";
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      theme = {
        name = "catppuccin-gtk";
        package = pkgs.catppuccin-gtk;
      }; # end of theme
    }; # end of gtk

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      }; # end of "org/gnome/desktop/interface"
    }; # end of dconf.settings
  }; # end of config
}
