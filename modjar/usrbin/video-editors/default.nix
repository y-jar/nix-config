{
  config,
  lib,
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
      kdenlive = lib.mkOption {
        type = lib.types.bool;
        default = false;
      }; # end of kdenlive
    }; # end of videoEditors
  }; # end of options
  config = {
    programs.kdePackages.kdenlive = {
      enable = cfg.kdenlive;
    };
  };
}
