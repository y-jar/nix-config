# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: GNOME desktop environment (system enable).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sysset.gnome;
in
{
  # options for gnome
  options = {
    sysset.gnome.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable GNOME desktop (~800MiB). Opt-in per host.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.desktopManager.gnome.enable = true;
    environment.gnome.excludePackages = [ ];
    environment.systemPackages = [
      # [gnome companion apps]
      pkgs.gnome-maps # Maps app for GNOME
      pkgs.gnome-tweaks # small things like font and scailing issues
      pkgs.gnome-nettool # Collection of networking tools
      pkgs.gnome-extension-manager # Desktop app for managing GNOME shell extensions
      pkgs.gnome-disk-utility # Udisks graphical front-end
      pkgs.gnome-usage # Nice way to view information about use of system resources, like memory and disk space
      pkgs.gnome-characters # Simple utility application to find and insert unusual characters
    ]; # end of extraPackages
  }; # end of config
}
