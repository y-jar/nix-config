# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: User home directories hjem side.
# =-=-=[directories] =-=-=
# Creates custom jar-prefixed directories in the
# home folder. Runs once via .profile on login (the dirSetup bus is
# declared in liijar/profile-bus.nix).
# =-=-=[end directories] =-=-=

{
  config,
  lib,
  ...
}:
let
  dirSetup = ''
    # [create jar directories]
    mkdir -p ~/resjar ~/rotjar ~/pic-jar ~/musicjar ~/kilnjar ~/artjar ~/entjar ~/entjar/mdachapters ~/docjar ~/vidjar ~/Downloads
  '';
in
{
  # always expose the dir setup it's harmless and idempotent
  config.hjemDotfiles.dirSetup = dirSetup;
}
