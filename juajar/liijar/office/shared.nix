# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Office shared data: libreoffice + pandoc packages.
# -=-=-=-=-=-=-=-=-=-=-=
# (the HM-only projectlibre/jupyter extras stay in hm.nix)
{
  cfg,
  pkgs,
  lib,
  ...
}:
{
  packages = with pkgs; [
    libreoffice # LibreOffice office suite
    # [Technical Writing]
    pandoc # Conversion between documentation formats
  ]; # end of packages
}
