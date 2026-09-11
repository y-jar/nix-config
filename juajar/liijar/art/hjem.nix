# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem art: shared per-sub-toggle image/3D/astronomy packages.
# -=-=-=-=-=-=-=-=-=-=-=
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
  config = {
    packages = shared.packages; # end of packages
  }; # end of config
}
