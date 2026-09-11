# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem flatpak: shared flatpak + bazaar packages + XDG_DATA_DIRS.
# -=-=-=-=-=-=-=-=-=-=-=
# The env line lands in hjem's user environment -> .profile.
# (home-manager hosts write it via home.sessionVariables instead)
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.flatpak;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{
  config = lib.mkIf cfg.enable {
    packages = shared.packages; # end of packages
    environment.sessionVariables = shared.sessionVariables; # end of sessionVariables
  }; # end of config
}
