# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Syncthing file sync (web UI :8384).
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/syncthing/hm.nix] =-=-=
# home-manager backend only hjem hosts never had syncthing, so this app
# ships no hjem.nix (the liijar/hjem.nix auto-import skips it).
# =-=-=[end liijar/syncthing/hm.nix] =-=-=
{
  config,
  lib,
  ...
}:
let
  cfg = config.usrset.syncthing;
in
{
  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
    };
  };
}
