{ ... }:
{
  imports = [
    ./display-pkgs.nix # anything DE or WM asisting pkgs
    # WMs
    ./WM-hyprland.nix # enables hyprland
    ./WM-niri.nix # enables niri
  ];
  # DEs
  services.desktopManager.gnome.enable = true;

  # services.mako.enable = true; # enable notifications
}
