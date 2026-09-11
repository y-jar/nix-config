# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem keepass: shared keepassxc package.
# -=-=-=-=-=-=-=-=-=-=-=
# (home-manager hosts install it via programs.keepassxc)
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.keepass;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{
  config = lib.mkIf cfg.enable {
    packages = shared.packages; # end of packages
  }; # end of config
}
