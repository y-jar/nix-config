# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: media: mpv.conf + mimeapps.list generation + per-bucket media packages.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.media;

  # webtoon-dl (from the old webtoon-dl module): downloads webtoon.com
  # comics as PDF or CBZ
  webtoonDl = pkgs.buildGoModule {
    pname = "webtoon-dl";
    version = "latest";

    src = pkgs.fetchFromGitHub {
      owner = "robinovitch61";
      repo = "webtoon-dl";
      rev = "main";
      hash = "sha256-QS4cW12YsP2jsRmLUXYQwxLq/w3poTiWj0Dgmg3kzFQ=";
    };

    vendorHash = "sha256-TnorRfbxOK5MBQOVlUFOO77wZNyMK0CP+qeqDpZAnro=";
    # ^ paste the sha256-... hash you got from the nix-build run here

    env.CGO_ENABLED = 0;
    ldflags = [
      "-s"
      "-w"
    ];

    meta = with lib; {
      description = "A CLI for downloading webtoon.com comics as PDF or CBZ";
      homepage = "https://github.com/robinovitch61/webtoon-dl";
      license = licenses.mit;
      mainProgram = "webtoon-dl";
    };
  };

  # per-sub-toggle media package buckets
  mediaPackages =
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
        qbittorrent # torrent client
        webtoonDl # webtoon.com comics as PDF/CBZ
      ]
    )
    ++ lib.optionals (cfg.enable && cfg.defaultApps) (
      with pkgs;
      [
        loupe # image viewer (GTK4/Rust, Wayland-native)
        showtime # video player (GNOME)
        file-roller # archive manager (GNOME)
      ]
    ); # end of mediaPackages

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
    # browser (${config.usrset.browsers.default or "firefox"})
    text/html=${config.usrset.browsers.default or "firefox"}.desktop
    x-scheme-handler/http=${config.usrset.browsers.default or "firefox"}.desktop
    x-scheme-handler/https=${config.usrset.browsers.default or "firefox"}.desktop
    x-scheme-handler/about=${config.usrset.browsers.default or "firefox"}.desktop
    x-scheme-handler/unknown=${config.usrset.browsers.default or "firefox"}.desktop
  '';
in
{
  # NOTE: lib.mkMerge, not `//` the attrset-update operator does not compose
  # module properties (mkIf); the old `// lib.mkIf` form silently dropped every
  # branch but the last (and any plain keys like packages).
  config = lib.mkMerge [
    { packages = mediaPackages; }
    (lib.mkIf cfg.enable {
      files.".config/mimeapps.list".source = mimeApps;
    })
    (lib.mkIf cfg.mpv {
      files.".config/mpv/mpv.conf".source = mpvConf;
    })
  ];
}
