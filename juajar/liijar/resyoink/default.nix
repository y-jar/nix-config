# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: symlink resource repos (wallpapers/icons/pfps) into ~/resjar.
# -=-=-=-=-=-=-=-=-=-=-=
# Flake inputs:
#   wall-jar    -> resjar/wall-jar
#   icon-jar    -> resjar/icon-jar
#   pfp-jar     -> resjar/pfp-jar
#   mcskins-jar -> resjar/mcskins-jar
{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.usrset.resYoink;

  # home-relative path -> flake input (null = toggle off)
  resyoinkFiles = {
    "resjar/wall-jar" = if cfg.wallpapers then inputs.wall-jar else null;
    "resjar/icon-jar" = if cfg.icons then inputs.icon-jar else null;
    "resjar/pfp-jar" = if cfg.profilePictures then inputs.pfp-jar else null;
    "resjar/mcskins-jar" = if cfg.minecraftSkins then inputs.mcskins-jar else null;
  }; # end of resyoinkFiles

  # [filter out entries with no source]
  activeFiles = lib.filterAttrs (_: v: v != null) resyoinkFiles;
in
{
  config = lib.mkIf cfg.enable {
    files = lib.mapAttrs (_: v: { source = v; }) activeFiles;
  }; # end of config
}
