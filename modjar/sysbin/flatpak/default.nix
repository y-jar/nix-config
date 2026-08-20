# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Flatpak support (system-level) + Bazaar setup.
# -=-=-=-=-=-=-=-=-=-=-=
{ lib, config, ... }:

let
  cfg = config.sysSettings.flatpak;
in
{
  options = {
    sysSettings.flatpak = {
      enable = lib.mkEnableOption "Enable flatpaks";
    };
  };

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
    xdg.portal.enable = true;
  };
}
