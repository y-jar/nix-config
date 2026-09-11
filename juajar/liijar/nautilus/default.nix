# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: nautilus GUI file explorer package.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.nautilus;

  nautilusPackages = [ pkgs.nautilus ]; # end of nautilusPackages
in
{
  config = lib.mkIf cfg.enable {
    packages = nautilusPackages; # end of packages
  }; # end of config
}
