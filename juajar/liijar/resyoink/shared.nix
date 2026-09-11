# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Resource symlinks shared data (flake inputs -> ~/resjar paths).
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/resyoink/shared.nix] =-=-=
# Pure data shared by both backends: home-relative path -> flake input
# (null = toggle off). Each backend filters out the null entries and maps
# the rest into its file option (HM: home.file, hjem: files).
#
# Flake inputs:
#   wall-jar    -> resjar/wall-jar
#   icon-jar    -> resjar/icon-jar
#   pfp-jar     -> resjar/pfp-jar
#   mcskins-jar -> resjar/mcskins-jar
# =-=-=[end liijar/resyoink/shared.nix] =-=-=
{
  cfg,
  inputs,
  ...
}:

{
  # home-relative path -> flake input (null = skip)
  files = {
    "resjar/wall-jar" = if cfg.wallpapers then inputs.wall-jar else null;
    "resjar/icon-jar" = if cfg.icons then inputs.icon-jar else null;
    "resjar/pfp-jar" = if cfg.profilePictures then inputs.pfp-jar else null;
    "resjar/mcskins-jar" = if cfg.minecraftSkins then inputs.mcskins-jar else null;
  };
}
