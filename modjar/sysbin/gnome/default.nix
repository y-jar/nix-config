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
    sysSettings.gnome.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable GNOME desktop";
    };
  };

  config = lib.mkIf cfg.enable {
    services.desktopManager.gnome.enable = true;
    environment.gnome.excludePackages = [ ];
    environment.systemPackages = with pkgs; [
      # [gnome companion apps]
      gnome-maps # Maps app for GNOME
      gnome-tweaks # small things like font and scailing issues
      gnome-nettool # Collection of networking tools
      gnome-extension-manager # Desktop app for managing GNOME shell extensions
      gnome-disk-utility # Udisks graphical front-end
      gnome-usage # Nice way to view information about use of system resources, like memory and disk space
      gnome-characters # Simple utility application to find and insert unusual characters
    ]; # end of extraPackages

  }; # end of config
}
