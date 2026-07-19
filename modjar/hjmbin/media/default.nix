# =-=-=[media] =-=-=
# Generates mpv.conf configuration.
# ref: modjar/usrbin/media/default.nix
# =-=-=[end media] =-=-=

{
  config,
  lib,
  pkgs,
  ...
}:
let
  hjm = config.hjmSettings;

  mpvConf = pkgs.writeText "mpv.conf" ''
    profile=high-quality
    ytdl-format=bestvideo+bestaudio
    cache-default=4000000
  '';
in
{
  config = lib.mkIf hjm.media.enable {
    hjemDotfiles.mpvConf = mpvConf;
  };
}
