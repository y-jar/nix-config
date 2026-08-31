# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Syncthing continuous file sync (web UI :8384).
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  config,
  ...
}:
let
  cfg = config.sysSettings.syncthing;
in
{
  options = {
    sysSettings.syncthing.enable = lib.mkEnableOption "Syncthing file sync (web UI at localhost:8384)";
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
    };
  }; # end of syncthing config
}