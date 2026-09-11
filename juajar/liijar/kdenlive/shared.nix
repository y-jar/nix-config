# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Kdenlive shared data: kdePackages.kdenlive package.
# -=-=-=-=-=-=-=-=-=-=-=
# Unified to kdePackages.kdenlive (the old hjmbin bucket used the plain
# `kdenlive` alias — same derivation family, now both sides match).
{
  cfg,
  pkgs,
  lib,
  ...
}:
{
  packages = [ pkgs.kdePackages.kdenlive ]; # end of packages
}
