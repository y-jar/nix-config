# pull desktop, for ./ui-bin/default.nix
{ pkgs, desktop, ... }:
{
  #============================Imports================================
  imports = [
    ./user_pkgs.nix # all the pkgs needed
    ./ui-jar/default.nix # Anything user UI related: waybar, niri, hyprland...
    ./zsh.nix # Shell
    ./app-bin/default.nix # APP CONFIGS
    ./git.nix # GIT SETTINGS
  ];

  #===============================Base Setup================================
  # basic stats
  home.username = "jar";
  home.homeDirectory = "/home/jar";
  home.stateVersion = "25.11";
  
  #===============================FONTS&THEME======================================
  # Font enable
  fonts.fontconfig.enable = true;
  gtk = {
    enable = false;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
  };
}
