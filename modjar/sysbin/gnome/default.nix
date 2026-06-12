{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sysSettings.gnome;
in
{
  # options for gnome
  options = {
    sysSettings.gnome.enable = {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.gnome = {
      enable = true;
      extraPackages = with pkgs; [
        # [gnome companion apps]
        gnome-maps # Maps app for GNOME
        gnome-tweaks # small things like font and scailing issues
        gnome-nettool # Collection of networking tools
        gnome-extension-manager # Desktop app for managing GNOME shell extensions
        gnome-disk-utility # Udisks graphical front-end
        gnome-usage # Nice way to view information about use of system resources, like memory and disk space
        gnome-characters # Simple utility application to find and insert unusual characters
      ]; # end of extraPackages
    }; # end of services.gnome
    # environment.gnome.excludePackages = with pkgs; [
    #   orca
    #   evince
    #   # file-roller
    #   geary
    #   gnome-disk-utility
    #   # seahorse
    #   # sushi
    #   # sysprof
    #   #
    #   # gnome-shell-extensions
    #   #
    #   # adwaita-icon-theme
    #   # nixos-background-info
    #   gnome-backgrounds
    #   # gnome-bluetooth
    #   # gnome-color-manager
    #   # gnome-control-center
    #   # gnome-shell-extensions
    #   gnome-tour # GNOME Shell detects the .desktop file on first log-in.
    #   gnome-user-docs
    #   # glib # for gsettings program
    #   # gnome-menus
    #   # gtk3.out # for gtk-launch program
    #   # xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
    #   # xdg-user-dirs-gtk # Used to create the default bookmarks
    #   #
    #   baobab
    #   epiphany
    #   gnome-text-editor
    #   gnome-calculator
    #   gnome-calendar
    #   gnome-characters
    #   # gnome-clocks
    #   gnome-console
    #   gnome-contacts
    #   gnome-font-viewer
    #   gnome-logs
    #   gnome-maps
    #   gnome-music
    #   # gnome-system-monitor
    #   gnome-weather
    #   # loupe
    #   # nautilus
    #   gnome-connections
    #   simple-scan
    #   snapshot
    #   totem
    #   yelp
    #   gnome-software
    # ]; # end of excludePackages
  }; # end of config
}
