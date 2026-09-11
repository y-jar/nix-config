# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Syncthing continuous file sync (web UI :8384), running as the main user.
# -=-=-=-=-=-=-=-=-=-=-=
# Runs as a system service but as the mainUser with their home dirs the
# same dirs/identity the old home-manager user service used, so existing
# sync configs keep working. hjemkey bridges usrset.syncthing.enable here,
# so hosts toggle it from their user.nix as before.
{
  lib,
  config,
  ...
}:
let
  cfg = config.sysset.syncthing;
in
{
  options = {
    sysset.syncthing.enable = lib.mkEnableOption "Syncthing file sync (web UI at localhost:8384)";
  }; # end of options

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = config.sysset.mainUser; # run as the main user (old user-service behavior)
      group = "users";
      dataDir = "/home/${config.sysset.mainUser}/.local/share/syncthing";
      configDir = "/home/${config.sysset.mainUser}/.config/syncthing";
    }; # end of syncthing
  }; # end of config
}
