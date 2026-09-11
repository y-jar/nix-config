# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Media playback tools (mpv + music players + ffmpeg).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.media;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{
  imports = [
    ./webtoon-dl.nix
  ];

  config = lib.mkIf cfg.enable {
    # [mpv] ref: https://wiki.nixos.org/wiki/MPV
    programs.mpv = lib.mkIf cfg.mpv {
      enable = true;
      config = {
        profile = "high-quality";
        ytdl-format = "bestvideo+bestaudio";
        cache-default = 4000000;
      };
    }; # end of programs.mpv

    # [default applications]
    xdg.mimeApps = lib.mkIf cfg.defaultApps {
      enable = true;
      defaultApplications = {
        # [image viewer] loupe
        "image/png" = "org.gnome.Loupe.desktop";
        "image/jpeg" = "org.gnome.Loupe.desktop";
        "image/gif" = "org.gnome.Loupe.desktop";
        "image/webp" = "org.gnome.Loupe.desktop";
        "image/svg+xml" = "org.gnome.Loupe.desktop";
        "image/tiff" = "org.gnome.Loupe.desktop";
        "image/bmp" = "org.gnome.Loupe.desktop";
        "image/x-portable-pixmap" = "org.gnome.Loupe.desktop";

        # [video player] showtime (GNOME)
        "video/mp4" = "org.gnome.Showtime.desktop";
        "video/x-matroska" = "org.gnome.Showtime.desktop";
        "video/webm" = "org.gnome.Showtime.desktop";
        "video/x-msvideo" = "org.gnome.Showtime.desktop";
        "video/quicktime" = "org.gnome.Showtime.desktop";
        "video/x-flv" = "org.gnome.Showtime.desktop";
        "video/mpeg" = "org.gnome.Showtime.desktop";

        # [audio player] mpv
        "audio/mpeg" = "mpv.desktop";
        "audio/flac" = "mpv.desktop";
        "audio/ogg" = "mpv.desktop";
        "audio/x-wav" = "mpv.desktop";
        "audio/aac" = "mpv.desktop";
        "audio/mp4" = "mpv.desktop";
        "audio/x-flac" = "mpv.desktop";

        # [text editor] neovim
        "text/plain" = "nvim.desktop";

        # [archive manager] file-roller (GNOME)
        "application/zip" = "org.gnome.FileRoller.desktop";
        "application/gzip" = "org.gnome.FileRoller.desktop";
        "application/x-tar" = "org.gnome.FileRoller.desktop";
        "application/x-bzip2" = "org.gnome.FileRoller.desktop";
        "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
        "application/x-rar" = "org.gnome.FileRoller.desktop";
        "application/x-xz" = "org.gnome.FileRoller.desktop";

        # [comic reader] yacreader
        "application/x-cbz" = "YACReader.desktop";
        "application/vnd.comicbook+zip" = "YACReader.desktop";
      }; # end of defaultApplications
    }; # end of xdg.mimeApps

    # [media apps, bulk] (hm-only extra: qbittorrent)
    home.packages =
      shared.packages
      ++ lib.optionals cfg.downloaders [
        pkgs.qbittorrent # torrent client
      ]; # end of home.packages
  }; # end of config
}
