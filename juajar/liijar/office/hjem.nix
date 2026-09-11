# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem office: shared libreoffice + pandoc packages.
# -=-=-=-=-=-=-=-=-=-=-=
# (home-manager hosts keep the projectlibre/jupyter extras in hm.nix)
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.office;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{
  config = lib.mkIf cfg.enable {
    packages = shared.packages; # end of packages
  }; # end of config
}
