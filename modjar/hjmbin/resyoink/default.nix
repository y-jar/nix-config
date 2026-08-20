# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem: resource symlinks.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[resyoink]=-=-=
# Symlinks wallpapers, icons, and profile pictures
# from flake inputs into ~/resjar/.
#
# Flake inputs:
#   wall-jar  -> resjar/wall-jar
#   icon-jar  -> resjar/icon-jar
#   pfp-jar   -> resjar/pfp-jar
# =-=-=[end resyoink]=-=-=

{
  config,
  lib,
  inputs,
  ...
}:
let
  hjm = config.hjmSettings;

  resYoinkAttr = {
    wallpapers = if hjm.resYoink.wallpapers then inputs.wall-jar else null;
    icons = if hjm.resYoink.icons then inputs.icon-jar else null;
    profilePictures = if hjm.resYoink.profilePictures then inputs.pfp-jar else null;
  };

  # [filter out null values]
  filteredResYoink = lib.filterAttrs (n: v: v != null) resYoinkAttr;
in
{
  config = lib.mkIf hjm.resYoink.enable {
    hjemDotfiles.resYoink = filteredResYoink;
  };
}
