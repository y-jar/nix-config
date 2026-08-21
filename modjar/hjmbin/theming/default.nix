# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem: theming (catppuccin gtk/qt + kvantum + cursor).
# -=-=-=-=-=-=-=-=-=-=-=
# ref: modjar/usrbin/theming/{default,gtk,qt}.nix
# hjem has no native gtk/qt/pointerCursor modules, so we generate the
# equivalent config files (gtk settings.ini, kvantum, cursor index.theme)
# and hand them to hjemkey.nix to write into ~/.config.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  hjm = config.hjmSettings;
  flavor = hjm.theming.flavor;
  accent = hjm.theming.accent;

  gtkThemeName = "catppuccin-${flavor}-${accent}-standard";
  iconThemeName = "Papirus-Dark";
  cursorName = "jcsr";
  qtThemeName = "catppuccin-${flavor}-${accent}";

  settingsIni = pkgs.writeText "settings.ini" ''
    [Settings]
    gtk-theme-name=${gtkThemeName}
    gtk-icon-theme-name=${iconThemeName}
    gtk-cursor-theme-name=${cursorName}
    gtk-application-prefer-dark-theme=1
  '';

  kvantumConfig = pkgs.writeText "kvantum.kvconfig" ''
    [General]
    theme=${qtThemeName}
  '';

  cursor = pkgs.runCommand "jcsr" { } ''
    mkdir -p $out/share/icons/jcsr
    cp -r ${../../usrbin/theming/cursors/jcsr}/* $out/share/icons/jcsr/
  '';

  indexTheme = pkgs.writeText "index.theme" ''
    [Icon Theme]
    Name=${cursorName}
    Comment=Custom cursor theme
    Inherits=${cursorName}
  '';
in
{
  config = lib.mkIf hjm.theming.enable {
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

    hjemDotfiles = {
      inherit settingsIni;
      inherit kvantumConfig;
      pointerCursorIndex = indexTheme;
      kvantumThemeDir = "${
        pkgs.catppuccin-kvantum.override {
          accent = accent;
          variant = flavor;
        }
      }/share/Kvantum/${qtThemeName}";
      kvantumThemeName = qtThemeName;
    };
  };
}
