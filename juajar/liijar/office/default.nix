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
      pkgs.hunspell # Spellchecker
      pkgs.hunspellDicts.en_US # Hunspell dictionary for English (United States) from Wordlist
      # pkgs.hunspellDicts.en_GB #
      # [Technical Writing]
      pkgs.pandoc # Conversion between documentation formats
      pkgs.projectlibre # Project-Management Software similar to MS-Project
      pkgs.jupyter # Web-based notebook environment for interactive computing; mainly used for school and notetaking
    ]; # end of packages
  }; # end of config
}
