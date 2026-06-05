{ pkgs, ... }:
{
  # gtk settings
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "nordic";
      package = pkgs.nordic;
    };
  };
  #
  qt = {
    enable = true;
    platformTheme.name = "gtk"; # makes Qt follow GTK theme
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
}
