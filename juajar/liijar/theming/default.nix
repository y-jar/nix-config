# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: theming: pseudo-gruvbox gtk/qt + kvantum + cursor + palette.
# -=-=-=-=-=-=-=-=-=-=-=
# Publishes `usrset.theming.colors` (the shared gruvbox palette every other
# module reads) and, when enabled, installs the GTK/Qt/icon/cursor stack.
#
# hjem has no native gtk/qt/pointerCursor modules, so we generate the
# equivalent config files (gtk settings.ini, kvantum, cursor index.theme,
# libadwaita gtk-4.0 links) and write them into the user `files` option.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.theming;
  inherit (cfg) accent variant;

  # central palette (single source of truth for every app module)
  palette = import ./palette.nix { inherit (cfg) accent variant blackness; };
  inherit (palette) colors;

  dark = variant == "dark";

  # gruvbox-gtk-theme dir: Gruvbox [+ -Accent] + -Dark|-Light
  accentCap = {
    orange = "Orange";
    red = "Red";
    yellow = "Yellow";
    green = "Green";
    teal = "Teal";
    purple = "Purple";
    pink = "Pink";
    grey = "Grey";
    default = "";
  };
  accentSuffix = if accent == "default" then "" else "-${accentCap.${accent}}";
  gtkThemeName = "Gruvbox${accentSuffix}-${if dark then "Dark" else "Light"}";

  # gruvbox-plus-icons folder color (orange stays the warm star)
  folderColor = {
    orange = "orange";
    red = "red";
    yellow = "yellow";
    green = "green";
    teal = "green";
    purple = "purple";
    pink = "violet";
    grey = "grey";
    default = "orange";
  };
  iconThemeName = "Gruvbox-Plus-${if dark then "Dark" else "Light"}";

  # kvantum has no orange; brown is the warm stand-in. nixpkgs names the dark
  # variant Gruvbox-Dark-* (hyphens) but the light variants with underscores.
  kvantumVariant = if dark then "Gruvbox-Dark-Brown" else "Gruvbox_Light_Brown";

  cursorName = "jcsr";

  gtkTheme = pkgs.gruvbox-gtk-theme.override {
    colorVariants = [ (if dark then "dark" else "light") ];
    themeVariants = [ accent ];
    sizeVariants = [ "standard" ];
    tweakVariants = lib.optionals (cfg.blackness && dark) [ "black" ];
  };

  iconsTheme = pkgs.gruvbox-plus-icons.override {
    folder-color = folderColor.${accent} or "orange";
  };

  kvantumTheme = pkgs.gruvbox-kvantum.override {
    variant = kvantumVariant;
  };

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
    theme=${kvantumVariant}
  '';

  # point Qt6 (qt6ct platform theme, QT_QPA_PLATFORMTHEME_QT6=qtct) at our
  # icon theme so QIcon::fromTheme stops falling back to bare hicolor.
  qt6ctConfig = pkgs.writeText "qt6ct.conf" ''
    [Appearance]
    icon_theme=${iconThemeName}
    style=kvantum
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

  # libadwaita apps (GTK4) only read gtk.css from ~/.config/gtk-4.0, not the
  # theme name in settings.ini; link the built theme's gtk-4.0 in.
  gtk4 = "${gtkTheme}/share/themes/${gtkThemeName}/gtk-4.0";

  # btop theme (read from ~/.config/btop/themes via core's btop.conf)
  btopTheme = pkgs.writeText "jargruv.theme" ''
    theme[main_bg]="${colors.bg1}"
    theme[main_fg]="${colors.fg0}"
    theme[title]="${colors.fg0}"
    theme[hi_fg]="${colors.accent}"
    theme[selected_bg]="${colors.bg3}"
    theme[selected_fg]="${colors.fg0}"
    theme[inactive_fg]="${colors.grey}"
    theme[graph_text]="${colors.fg2}"
    theme[meter_bg]="${colors.bg4}"
    theme[proc_misc]="${colors.accent}"
    theme[cpu_box]="${colors.purple}"
    theme[mem_box]="${colors.green}"
    theme[net_box]="${colors.blue}"
    theme[proc_box]="${colors.accent}"
    theme[div_line]="${colors.bg4}"
    theme[temp_start]="${colors.greenBright}"
    theme[temp_mid]="${colors.yellow}"
    theme[temp_end]="${colors.red}"
    theme[cpu_start]="${colors.green}"
    theme[cpu_mid]="${colors.yellow}"
    theme[cpu_end]="${colors.red}"
    theme[free_start]="${colors.purple}"
    theme[free_mid]="${colors.purpleBright}"
    theme[free_end]="${colors.yellow}"
    theme[cached_start]="${colors.blue}"
    theme[cached_mid]="${colors.blueBright}"
    theme[cached_end]="${colors.aqua}"
    theme[available_start]="${colors.greenBright}"
    theme[available_mid]="${colors.yellow}"
    theme[available_end]="${colors.red}"
    theme[used_start]="${colors.blue}"
    theme[used_mid]="${colors.blueBright}"
    theme[used_end]="${colors.green}"
    theme[download_start]="${colors.blue}"
    theme[download_mid]="${colors.blueBright}"
    theme[download_end]="${colors.green}"
    theme[upload_start]="${colors.purple}"
    theme[upload_mid]="${colors.purpleBright}"
    theme[upload_end]="${colors.red}"
  '';

  # GTK2 (gtkrc-2.0). GTK2 ignores settings.ini, so set the theme/icons/cursor
  # here directly. This also clobbers the stale home-manager symlink that still
  # pointed at the removed catppuccin theme.
  gtk2rc = pkgs.writeText "gtkrc-2.0" ''
    gtk-theme-name = "${gtkThemeName}"
    gtk-icon-theme-name = "${iconThemeName}"
    gtk-cursor-theme-name = "${cursorName}"
    gtk-cursor-theme-size = ${toString cfg.cursorSize}
  '';

  # GTK3 user css. The stale home-manager gtk.css only carried an emoji
  # keybinding (no colors), so we take it over to keep that binding AND clobber
  # the orphaned symlink. Theme colors come from settings.ini, not here.
  gtk3Css = pkgs.writeText "gtk3.css" ''
    @binding-set EmojiSelectRemap {
      unbind "<Control>period";
      unbind "<Control>semicolon";
      bind "<Super><Alt>space" { "insert-emoji" () };
    }
    entry, textview {
      -gtk-key-bindings: EmojiSelectRemap;
    }
  '';
in
{
  config = lib.mkMerge [
    # palette + theme names are always published, themed or not
    {
      usrset.theming.colors = colors;
      usrset.theming.gtkThemeName = gtkThemeName;
      usrset.theming.iconThemeName = iconThemeName;
    }

    (lib.mkIf cfg.enable {
      packages = [
        gtkTheme
        iconsTheme
        kvantumTheme
        pkgs.kdePackages.qtstyleplugin-kvantum
        pkgs.libsForQt5.qtstyleplugin-kvantum
        pkgs.kdePackages.qt6ct
        pkgs.libsForQt5.qt5ct
        pkgs.hicolor-icon-theme
        pkgs.adwaita-icon-theme
        cursor
      ];

      files = {
        ".config/gtk-3.0/settings.ini".source = settingsIni;
        ".config/gtk-3.0/gtk.css".source = gtk3Css;
        ".config/gtk-3.0/colors.css".text = ""; # clobber stale home-manager breeze leftovers
        ".config/gtk-4.0/settings.ini".source = settingsIni;
        ".config/gtk-4.0/gtk.css".source = "${gtk4}/gtk.css";
        ".config/gtk-4.0/gtk-dark.css".source = "${gtk4}/gtk-dark.css";
        ".config/gtk-4.0/assets".source = "${gtk4}/assets";
        ".config/gtk-4.0/colors.css".text = ""; # clobber stale home-manager breeze leftovers
        ".config/qt6ct/qt6ct.conf".source = qt6ctConfig;
        ".config/Kvantum/kvantum.kvconfig".source = kvantumConfig;
        ".config/Kvantum/${kvantumVariant}".source = "${kvantumTheme}/share/Kvantum/${kvantumVariant}";
        ".icons/jcsr".source = "${cursor}/share/icons/jcsr";
        ".icons/default/index.theme".source = indexTheme;
        # also expose under XDG data so flatpak/portal apps find them
        ".local/share/themes/${gtkThemeName}".source = "${gtkTheme}/share/themes/${gtkThemeName}";
        ".local/share/icons/${iconThemeName}".source = "${iconsTheme}/share/icons/${iconThemeName}";
        # GTK2 (clobbers the stale home-manager .gtkrc-2.0 symlink)
        ".gtkrc-2.0".source = gtk2rc;
        # replace the stale home-manager Qt environment file (was kvantum)
        ".config/environment.d/10-home-manager.conf".text = ''
          QT_QPA_PLATFORMTHEME=qtct
          QT_QPA_PLATFORMTHEME_QT6=qtct
          QT_STYLE_OVERRIDE=kvantum
        '';
        # btop theme (only themed when theming is on)
        ".config/btop/themes/jargruv.theme".source = btopTheme;
      };
      environment.sessionVariables.GTK_THEME = gtkThemeName;
    })
  ];
}
