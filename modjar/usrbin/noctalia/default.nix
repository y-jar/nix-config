{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      noctalia-shell # Sleek and minimal desktop shell thoughtfully crafted for Wayland, built with Quickshell
    ];
  };
}
