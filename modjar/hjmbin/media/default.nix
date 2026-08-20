# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem: mpv + mimeapps dotfiles.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[media] =-=-=
# Generates mpv.conf and mimeapps.list configuration.
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

  mimeApps = pkgs.writeText "mimeapps.list" ''
    [Default Applications]
    # image viewer (loupe)
    image/png=org.gnome.Loupe.desktop
    image/jpeg=org.gnome.Loupe.desktop
    image/gif=org.gnome.Loupe.desktop
    image/webp=org.gnome.Loupe.desktop
    image/svg+xml=org.gnome.Loupe.desktop
    image/tiff=org.gnome.Loupe.desktop
    image/bmp=org.gnome.Loupe.desktop
    image/x-portable-pixmap=org.gnome.Loupe.desktop
    # video player (showtime)
    video/mp4=org.gnome.Showtime.desktop
    video/x-matroska=org.gnome.Showtime.desktop
    video/webm=org.gnome.Showtime.desktop
    video/x-msvideo=org.gnome.Showtime.desktop
    video/quicktime=org.gnome.Showtime.desktop
    video/x-flv=org.gnome.Showtime.desktop
    video/mpeg=org.gnome.Showtime.desktop
    # audio player (mpv)
    audio/mpeg=mpv.desktop
    audio/flac=mpv.desktop
    audio/ogg=mpv.desktop
    audio/x-wav=mpv.desktop
    audio/aac=mpv.desktop
    audio/mp4=mpv.desktop
    audio/x-flac=mpv.desktop
    # text editor (neovim)
    text/plain=nvim.desktop
    # archive manager (file-roller)
    application/zip=org.gnome.FileRoller.desktop
    application/gzip=org.gnome.FileRoller.desktop
    application/x-tar=org.gnome.FileRoller.desktop
    application/x-bzip2=org.gnome.FileRoller.desktop
    application/x-7z-compressed=org.gnome.FileRoller.desktop
    application/x-rar=org.gnome.FileRoller.desktop
    application/x-xz=org.gnome.FileRoller.desktop
    # comic reader (yacreader)
    application/x-cbz=YACReader.desktop
    application/vnd.comicbook+zip=YACReader.desktop
    # browser (firefox)
    text/html=firefox.desktop
    x-scheme-handler/http=firefox.desktop
    x-scheme-handler/https=firefox.desktop
    x-scheme-handler/about=firefox.desktop
    x-scheme-handler/unknown=firefox.desktop
  '';
in
{
  config = lib.mkIf hjm.media.enable {
    hjemDotfiles.mpvConf = mpvConf;
    hjemDotfiles.mimeApps = mimeApps;
  };
}
