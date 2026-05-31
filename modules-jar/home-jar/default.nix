# pull desktop, for ./ui-bin/default.nix
{ pkgs, desktop, ... }:
{
  #============================Imports================================
  imports = [
    ./user_pkgs.nix # all the pkgs needed
    ./ui-jar/default.nix # Anything user UI related: waybar, niri, hyprland...
    ./zsh.nix # Shell
    ./app-jar/default.nix # APP CONFIGS
    ./git.nix # GIT SETTINGS
    ./ui-jar/aplook_mngr.nix # sets my themes and other settings for gtk
  ];

  #===============================Base Setup================================
  # basic stats
  home.username = "jar";
  home.homeDirectory = "/home/jar";
  home.stateVersion = "26.05";
  
  #===============================FONTS&THEME======================================
  # Font enable
  fonts.fontconfig.enable = true;
  
}
