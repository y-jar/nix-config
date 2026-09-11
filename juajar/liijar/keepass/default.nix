# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: keepassxc password manager.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.keepass;
in
{
  config = lib.mkIf cfg.enable {
    packages = [ pkgs.keepassxc ]; # end of packages
  }; # end of config
}
