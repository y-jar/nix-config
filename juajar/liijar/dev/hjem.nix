# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem dev: shared per-sub-toggle toolchain packages.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.dev;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{
  config = {
    packages = shared.packages; # end of packages
  }; # end of config
}
