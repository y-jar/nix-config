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
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      kdenlive.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      }; # end of kdenlive
    }; # end of videoEditors
  }; # end of options
  config = lib.mkIf cfg.kdenlive.enable {
    home.packages = with pkgs; [
      kdePackages.kdenlive # for video editing
    ]; # end of home.packages
  };
}
