# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem obs: shared obs-studio package (no plugins).
# -=-=-=-=-=-=-=-=-=-=-=
# (home-manager hosts get obs + the six plugins via programs.obs-studio)
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.obs;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{
  config = lib.mkIf cfg.enable {
    packages = shared.packages; # end of packages
  }; # end of config
}
