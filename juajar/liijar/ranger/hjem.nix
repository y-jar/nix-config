# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem ranger: shared ranger package.
# -=-=-=-=-=-=-=-=-=-=-=
# (home-manager hosts install it via programs.ranger)
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.ranger;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{
  config = lib.mkIf cfg.enable {
    packages = shared.packages; # end of packages
  }; # end of config
}
