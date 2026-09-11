# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Core user packages (home-manager backend) + btop.
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
  imports = [
    ./btop.nix
  ];

  config = {
    home.packages = shared.packages;
  }; # end of config
}
