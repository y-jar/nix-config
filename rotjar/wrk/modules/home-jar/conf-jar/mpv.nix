{ config, pkgs, ... }:

{
  # ref https://wiki.nixos.org/wiki/MPV
  programs.mpv = {
    enable = true;
    config = {
      profile = "high-quality";
      ytdl-format = "bestvideo+bestaudio";
      cache-default = 4000000;
    }; # end of config
  }; # end of mpv
}
