# =-=-=[directories] =-=-=
# Creates custom jar-prefixed directories in the
# home folder. Runs once via .profile on login.
# =-=-=[end directories] =-=-=

{
  config,
  lib,
  ...
}:
let
  hjm = config.hjmSettings;

  dirSetup = ''
    # [create jar directories]
    mkdir -p ~/resjar ~/rotjar ~/pic-jar ~/musicjar ~/kilnjar ~/artjar ~/entjar ~/docjar ~/vidjar ~/Downloads
  '';
in
{
  # always expose the dir setup — it's harmless and idempotent
  config.hjemDotfiles.dirSetup = dirSetup;
}
