{
  config,
  lib,
  ...
}:
let
  cfg = config.sysSettings.gaming.heroic;
in
{
  options = {
    sysSettings.gaming.heroic = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables gaming";
    }; # end of sysSettings.gaming.heroic
  }; # end of options

  config = lib.mkIf cfg.enable {
    programs.heroic = {
      enable = true;
    };
  }; # end of config
}
