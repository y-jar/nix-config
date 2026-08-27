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
  cfg = config.usrSettings.media;
in
{
  imports = [
    ./defaultApps.nix
    ./webtoon-dl.nix
  ];

  options = {
    usrSettings.media = {
      enable = lib.mkEnableOption "media tools (master toggle)";
      mpv = lib.mkEnableOption "mpv video player + yt-dlp integration";
      downloaders = lib.mkEnableOption "ffmpeg + yt-dlp download/transcode CLI";
      musicApps = lib.mkEnableOption "music players (quodlibet, gapless, blanket)";
      audioEditor = lib.mkEnableOption "audacity audio editor";
      viewers = lib.mkEnableOption "misc viewers (yacreader, constrict, anki)";
      defaultApps = lib.mkEnableOption "default mime apps + loupe/showtime/file-roller";
    };
  };

  config = lib.mkIf cfg.enable {
    # [mpv] ref: https://wiki.nixos.org/wiki/MPV
    programs.mpv = lib.mkIf cfg.mpv {
      enable = true;
      config = {
        profile = "high-quality";
        ytdl-format = "bestvideo+bestaudio";
        cache-default = 4000000;
      };
    };

    # [media apps, bulk]
    home.packages = lib.mkMerge [
      (lib.mkIf cfg.musicApps (
        with pkgs;
        [
          blanket # background noises
          quodlibet # media player
          gapless # lightweight GTK4 music player
        ]
      ))
      (lib.mkIf cfg.audioEditor (
        with pkgs;
        [
          audacity # audio editor
        ]
      ))
      (lib.mkIf cfg.viewers (
        with pkgs;
        [
          yacreader # ebook/manga reader
          constrict # file shrinker
          anki # spaced-repetition flashcards
        ]
      ))
      (lib.mkIf cfg.downloaders (
        with pkgs;
        [
          ffmpeg
          yt-dlp # audio/video downloader
          qbittorrent # torrent client
        ]
      ))
    ];
  };
}
