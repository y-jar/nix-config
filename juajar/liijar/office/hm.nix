# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Office: LibreOffice + Pandoc.
# -=-=-=-=-=-=-=-=-=-=-=
# libreoffice/pandoc come from ./shared.nix; the extras below stayed
# home-manager-only in the old usrbin module, so they stay here.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.office;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{

  config = lib.mkIf cfg.enable {
    home.packages =
      shared.packages
      ++ (with pkgs; [
        projectlibre # Project-Management Software similar to MS-Project
        jupyter # Web-based notebook environment for interactive computing; mainly used for school and notetaking
      ]); # end of home.packages
  }; # end of config
}
