# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Creative suite: Blender + Krita + GIMP + Inkscape.
# -=-=-=-=-=-=-=-=-=-=-=
# Package buckets come from ./shared.nix (per-sub-toggle gated there).
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.art;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{

  config = lib.mkIf cfg.enable {
    home.packages = shared.packages; # end of home.packages
  }; # end of config
}
