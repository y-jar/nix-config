# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Heroic Games Launcher (GOG/Epic).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.gaming.heroic;
in
{

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.heroic
    ];
  }; # end of config
}
