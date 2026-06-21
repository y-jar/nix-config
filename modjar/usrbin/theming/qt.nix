{
  config,
  lib,
  pkgs,
  ...
}:
let
  # [options]
  cfg = config.theming;

  # [theme settings]
  catppuccinKvantum = pkgs.catppuccin-kvantum.override {
    accent = cfg.accent;
    variant = cfg.flavor;
  };
  qtThemeName = "catppuccin-${cfg.flavor}-${cfg.accent}";
in
{
  config = lib.mkIf cfg.enable {
    # [qt]
    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      # platformTheme.name = "gtk3" # use gtk3 theme instead of kvantum [if dis dont work ;-;]
      style.name = "kvantum";
      # no package needed here; home-manager resolves the kvantum
      # engine package automatically for these two named options.. nix hurts
    }; # end of qt

    # [pkgs]
    home.packages = [
      catppuccinKvantum # Catppuccin Kvantum theme
      pkgs.kdePackages.qtstyleplugin-kvantum # SVG-based Qt5 theme engine plus a config tool and extra themes
      pkgs.libsForQt5.qtstyleplugin-kvantum # SVG-based Qt5 theme engine plus a config tool and extra themes
      pkgs.kdePackages.qt6ct # Qt6 Configuration Tool - lets you confirm kvantum is registered
      pkgs.libsForQt5.qt5ct # Qt5 Configuration Tool, same purpose for Qt5 apps
    ]; # end of home.packages

    # [config]
    xdg.configFile = {
      "Kvantum/${qtThemeName}".source = "${catppuccinKvantum}/share/Kvantum/${qtThemeName}";
      "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
        General.theme = qtThemeName;
      }; # end of "Kvantum/kvantum.kvconfig"
    }; # end of xdg.configFile
  }; # end of config
}

#*/-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# ref: https://discourse.nixos.org/t/guide-to-installing-qt-theme/35523/2 [discussion where it is discussed]
# ref 2: https://github.com/heitorPB/dotfiles-supimpas [the repo i used as inspiration]
#*/-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
