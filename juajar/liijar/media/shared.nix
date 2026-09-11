# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Media shared data: per-sub-toggle media packages.
# -=-=-=-=-=-=-=-=-=-=-=
{
  cfg,
  pkgs,
  lib,
  ...
}:
{
  packages =
    lib.optionals (cfg.enable && cfg.mpv) [
      pkgs.mpv
    ]
    ++ lib.optionals (cfg.enable && cfg.musicApps) (
      with pkgs;
      [
        blanket # background noises
        quodlibet # media player
        gapless # lightweight GTK4 music player
        spotify # music streaming (unfree) ~300miB
      ]
    )
    ++ lib.optionals (cfg.enable && cfg.audioEditor) (
      with pkgs;
      [
        audacity # audio editor
      ]
    )
    ++ lib.optionals (cfg.enable && cfg.viewers) (
      with pkgs;
      [
        yacreader # ebook/manga reader
        constrict # file shrinker
        anki # spaced-repetition flashcards
      ]
    )
    ++ lib.optionals (cfg.enable && cfg.downloaders) (
      with pkgs;
      [
        ffmpeg
        yt-dlp # audio/video downloader
      ]
    )
    ++ lib.optionals (cfg.enable && cfg.defaultApps) (
      with pkgs;
      [
        loupe # image viewer (GTK4/Rust, Wayland-native)
        showtime # video player (GNOME)
        file-roller # archive manager (GNOME)
      ]
    ); # end of packages
}
