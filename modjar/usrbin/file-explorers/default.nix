{
  config,
  lib,
  ...
}:
let
  cfg = config.usrSettings.yazi;
  rangerCfg = config.usrSettings.ranger;
  nautilusCfg = config.usrSettings.nautilus;
in
{
  options = {
    usrSettings = {
      yazi = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
      };
      ranger = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };
      nautilus = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
      };
    };
  }; # end of options

  config = {
    programs.yazi = lib.mkIf cfg.enable {
      enable = true;
    }; # end of programs.yazi
    programs.ranger = lib.mkIf rangerCfg.enable {
      enable = true;
    }; # end of programs.ranger
    programs.nautilus = lib.mkIf nautilusCfg.enable {
      enable = true;
    }; # end of programs.nautilus
  };
}
