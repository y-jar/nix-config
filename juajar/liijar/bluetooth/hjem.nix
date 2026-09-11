# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Blueman GUI (hjem backend).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  shared = import ./shared.nix {
    cfg = config.usrset.bluetooth;
    inherit lib pkgs;
  };
in
{
  config = {
    packages = shared.packages; # installs blueman
  }; # end of config
}
