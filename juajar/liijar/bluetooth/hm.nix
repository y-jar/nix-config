# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Blueman GUI (home-manager backend).
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
    home.packages = shared.packages; # installs blueman
  }; # end of config
}
