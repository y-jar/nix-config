# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: ranger terminal file manager package.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.ranger;

  rangerPackages = [ pkgs.ranger ]; # end of rangerPackages
in
{
  config = lib.mkIf cfg.enable {
    packages = rangerPackages; # end of packages
  }; # end of config
}
