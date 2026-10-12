# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: symlink resource repos into ~/resjar.
# -=-=-=-=-=-=-=-=-=-=-=
# Flake inputs:
#   wall-jar    -> resjar/wall-jar
#   mcskins-jar -> resjar/mcskins-jar
#
# icon-jar is a flake now: its hjem module owns the bins and lets each system
# choose where they land. We just point the defaults at resjar/iconbin and
# resjar/pfpbin (contents dumped, not the whole repo dir).
#   iconbin -> resjar/iconbin  (jarRes.icons)
#   pfpbin  -> resjar/pfpbin   (jarRes.pfps)
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
    "resjar/mcskins-jar" = if cfg.minecraftSkins then inputs.mcskins-jar else null;
  }; # end of resyoinkFiles

  # [filter out entries with no source]
  activeFiles = lib.filterAttrs (_: v: v != null) resyoinkFiles;
in
{
  # icon-jar ships a hjem module; import it so jarRes.* options exist.
  imports = [ inputs.icon-jar.hjemModules.default ];

  config = lib.mkIf cfg.enable {
    files = lib.mapAttrs (_: v: { source = v; }) activeFiles;

    # icon-jar owns these bins: dump the contents into ~/resjar/{iconbin,pfpbin}.
    jarRes = {
      icons = {
        enable = cfg.icons;
        dest = "resjar/iconbin";
      };
      pfps = {
        enable = cfg.profilePictures;
        dest = "resjar/pfpbin";
      };
    };
  }; # end of config
}
