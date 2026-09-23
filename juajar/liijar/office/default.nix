# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: office: libreoffice + pandoc + projectlibre + jupyter.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.office;
in
{
  config = lib.mkIf cfg.enable {
    packages = [
      pkgs.libreoffice # LibreOffice office suite
      # [Technical Writing]
      pkgs.pandoc # Conversion between documentation formats
      pkgs.projectlibre # Project-Management Software similar to MS-Project
      pkgs.jupyter # Web-based notebook environment for interactive computing; mainly used for school and notetaking
    ]; # end of packages
  }; # end of config
}
