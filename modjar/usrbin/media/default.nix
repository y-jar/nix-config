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
    ./komga.nix
    ./defaultApps.nix
  ];

  options = {
    usrSettings.media.enable = lib.mkEnableOption "Enable media tools (~200MiB, mpv + ffmpeg + music players)";
  };
  config = lib.mkIf cfg.enable {
    # [MUSIC VIDEO]
    # ref: https://wiki.nixos.org/wiki/MPV
    programs.mpv = {
      enable = true;
      config = {
        profile = "high-quality";
        ytdl-format = "bestvideo+bestaudio";
        cache-default = 4000000;
      }; # end of config
    }; # end of mpv

    # [bulk appstream]
    home.packages = with pkgs; [
      blanket # Background noises
      quodlibet # media player
      gapless # Beautiful, fast, fluent, light weight music player written in GTK4 [but no gaps]
      audacity # Audio editor +55mib
      yacreader # Reader for Ebooks, manga, etc..
      constrict # shrinks files

      # [other]
      ffmpeg #
      yt-dlp # Feature-rich command-line audio/video downloader
      ytdownloader # Modern GUI video and audio downloader: [please don't use this for pirating, be kind]: requested from a sibling
    ]; # end of packages
  }; # enf of config
}
