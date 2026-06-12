{ pkgs, ... }:
{
  programs.kdeconnect.enable = false; # flip to true when you want it
  environment.systemPackages = with pkgs; [
    # [gnome companion apps]
    gnome-tweaks # small things like font and scailing issues
    gnome-nettool # Collection of networking tools
    gnome-extension-manager # Desktop app for managing GNOME shell extensions
    gnome-disk-utility # Udisks graphical front-end
    gnome-boxes # Simple GNOME 3 application to access remote or virtual systems
    gnome-usage # Nice way to view information about use of system resources, like memory and disk space
    gnome-characters # Simple utility application to find and insert unusual characters

    # [Niri / Wayland Environment Essentials]
    swaybg # Wallpaper tool for Wayland compositors
    waybar # Highly customizable Wayland bar for Sway and Wlroots based compositors
    fuzzel # Wayland-native application launcher, similar to rofi’s drun mode
    xwayland-satellite # Xwayland outside your Wayland compositor
    wl-clipboard # Command-line copy/paste utilities for Wayland
    xdg-utils # xdg-utils

    # [Hyprland Companion Apps]
    hyprshot # Utility to easily take screenshots in Hyprland using your mouse
    hyprlauncher # A multipurpose and versatile launcher / picker for Hyprland
    hyprlock # Hyprland’s GPU-accelerated screen locking utility
    hyprsunset # Application to enable a blue-light filter on Hyprland
  ];
}
