# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Video editors (Kdenlive).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.kdenlive;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{
  config = lib.mkIf cfg.enable {
    home.packages = shared.packages; # end of home.packages
  }; # end of config
}
