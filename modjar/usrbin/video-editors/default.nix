# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Video editors (Kdenlive).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.videoEditors;
in
{
  options = {
    usrSettings.videoEditors = {
      enable = lib.mkEnableOption "video editors (master toggle)";
      kdenlive.enable = lib.mkEnableOption "Kdenlive video editor";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.kdenlive.enable) {
    home.packages = with pkgs; [
      kdePackages.kdenlive
    ];
  };
}
