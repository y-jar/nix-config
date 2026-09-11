# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Core user packages (hjem backend).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  osConfig,
  inputs,
  ...
}:
let
  shared = import ./shared.nix {
    cfg = config.usrset;
    inherit
      lib
      pkgs
      osConfig
      inputs
      ;
  };
in
{
  config = {
    packages = shared.packages;
  }; # end of config
}
