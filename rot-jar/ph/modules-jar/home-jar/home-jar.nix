# pull desktop, for ./ui-bin/default.nix
{ pkgs, desktop, ... }:
{
  #============================Imports================================
  imports = [
    ./user-pkgs.nix # all the pkgs needed
    ./ui-jar/default.nix # Anything user UI related: waybar, niri, hyprland...
    ./app-jar/default.nix # APP CONFIGS
    ./zsh.nix # Shell
    ./git.nix # GIT SETTINGS
    ./input-methods.nix # KEYBOARD SETTINGS & CONFIGS
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
