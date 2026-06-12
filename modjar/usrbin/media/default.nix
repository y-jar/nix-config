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
  options = {
    usrSettings.media = lib.mkEnableOption "Enable media";
  };
  config = lib.mkIf cfg.enable {
    # MUSIC VIDEO
    # ref https://wiki.nixos.org/wiki/MPV
    programs.mpv = {
      enable = true;
      config = {
        profile = "high-quality";
        ytdl-format = "bestvideo+bestaudio";
        cache-default = 4000000;
      }; # end of config
    }; # end of mpv

    # IMAGES
    services.tumbler.enable = true; # image stuff
    programs.evince.enable = true; # Enablilng this native option automatically sets up PDF thumbnailing

    # bulk appstream
    home.packages = with pkgs; [
      blanket # Background noises
      quodlibet # media player
      gapless # Beautiful, fast, fluent, light weight music player written in GTK4 [but no gaps]
    ];
  }; # enf of config
}
