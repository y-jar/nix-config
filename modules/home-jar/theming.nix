{ pkgs, ... }:
{
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
    };
  };
  #
  qt = {
    enable = true;
    platformTheme.name = "qtct"; # makes Qt follow my theme
    style = {
      name = "kvantum";
      package = pkgs.adwaita-qt;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # install qt pkgs/// someday ill get this///
  home.packages = with pkgs; [
    qt6Packages.qt6ct # Qt6 Configuration Tool
    libsForQt5.qtstyleplugins # Additional style plugins for Qt5, including BB10, GTK, Cleanlooks, Motif, Plastique
    kdePackages.qt6ct # Qt6 Configuration Tool
    kdePackages.qtstyleplugin-kvantum # Qt6 Kvantum
    libsForQt5.qtstyleplugin-kvantum # Qt5 Kvantum
  ];
}
