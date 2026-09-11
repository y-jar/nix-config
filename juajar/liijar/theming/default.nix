# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: theming: catppuccin gtk/qt + kvantum + cursor.
# -=-=-=-=-=-=-=-=-=-=-=
# hjem has no native gtk/qt/pointerCursor modules, so we generate the
# equivalent config files (gtk settings.ini, kvantum, cursor index.theme)
# and write them into the user `files` option.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.theming;
  flavor = cfg.flavor;
  accent = cfg.accent;

  gtkThemeName = "catppuccin-${flavor}-${accent}-standard";
  iconThemeName = "Papirus-Dark";
  cursorName = "jcsr";
  qtThemeName = "catppuccin-${flavor}-${accent}";

  settingsIni = pkgs.writeText "settings.ini" ''
    [Settings]
    gtk-theme-name=${gtkThemeName}
    gtk-icon-theme-name=${iconThemeName}
    gtk-cursor-theme-name=${cursorName}
    gtk-cursor-theme-size=${toString cfg.cursorSize}
    gtk-application-prefer-dark-theme=1
  '';

  kvantumConfig = pkgs.writeText "kvantum.kvconfig" ''
    [General]
    theme=${qtThemeName}
  '';

  cursor = pkgs.runCommand "jcsr" { } ''
    mkdir -p $out/share/icons/jcsr
    cp -r ${./cursors/jcsr}/* $out/share/icons/jcsr/
  '';

  indexTheme = pkgs.writeText "index.theme" ''
    [Icon Theme]
    Name=${cursorName}
    Comment=Custom cursor theme
    Inherits=${cursorName}
  '';
in
{
  config = lib.mkIf cfg.enable {
    packages = [
      (pkgs.catppuccin-gtk.override {
        accents = [ accent ];
        size = "standard";
        variant = flavor;
      })
      (pkgs.catppuccin-papirus-folders.override {
        accent = accent;
        flavor = flavor;
      })
      pkgs.papirus-folders
      (pkgs.catppuccin-kvantum.override {
        accent = accent;
        variant = flavor;
      })
      pkgs.kdePackages.qtstyleplugin-kvantum
      pkgs.libsForQt5.qtstyleplugin-kvantum
      pkgs.kdePackages.qt6ct
      pkgs.libsForQt5.qt5ct
      cursor
    ];

    files = {
      ".config/gtk-3.0/settings.ini".source = settingsIni;
      ".config/gtk-4.0/settings.ini".source = settingsIni;
      ".config/Kvantum/kvantum.kvconfig".source = kvantumConfig;
      ".config/Kvantum/${qtThemeName}".source = "${
        pkgs.catppuccin-kvantum.override {
          accent = accent;
          variant = flavor;
        }
      }/share/Kvantum/${qtThemeName}";
      ".icons/jcsr".source = "${cursor}/share/icons/jcsr";
      ".icons/default/index.theme".source = indexTheme;
    };
  };
}
