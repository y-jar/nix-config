# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem desktop tweaks: ddcutil (desktop hosts only).
# -=-=-=-=-=-=-=-=-=-=-=
# Gated on the hasDesktop specialArg, matching the old hjmbin bucket.
# (the fuller session-variable set stays home-manager side in hm.nix)
{
  lib,
  pkgs,
  hasDesktop,
  ...
}:

{
  config = {
    packages = lib.optionals hasDesktop [ pkgs.ddcutil ]; # end of packages
  }; # end of config
}
