{ ... }:
{
  imports = [
    ./display-pkgs.nix # anything DE or WM asisting pkgs
  ];
  # DEs
  services.desktopManager.gnome.enable = true;
  # WMs
  programs.niri.enable = true;
  programs.hyprland.enable = true;
  # services.mako.enable = true; # enable notifications
}
