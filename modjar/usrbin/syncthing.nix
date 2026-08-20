# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Syncthing file sync (web UI :8384).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  ...
}:
let
  cfg = config.usrSettings.syncthing;
in
{
  options.usrSettings.syncthing = {
    enable = lib.mkEnableOption "Enable Syncthing file sync (web UI at localhost:8384)";
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
    };
  };
}
