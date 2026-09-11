# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Flatpak support (system-level) + Bazaar setup.
# -=-=-=-=-=-=-=-=-=-=-=
{ lib, config, ... }:

let
  cfg = config.sysset.flatpak;
in
{
  options = {
    sysset.flatpak = {
      enable = lib.mkEnableOption "Enable flatpaks";
    };
  };

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
    xdg.portal.enable = true;
  };
}
