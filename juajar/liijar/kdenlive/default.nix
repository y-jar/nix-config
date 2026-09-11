# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: kdenlive video editor package.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.kdenlive;

  kdenlivePackages = [ pkgs.kdePackages.kdenlive ]; # end of kdenlivePackages
in
{
  config = lib.mkIf cfg.enable {
    packages = kdenlivePackages; # end of packages
  }; # end of config
}
