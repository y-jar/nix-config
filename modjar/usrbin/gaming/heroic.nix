{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.gaming.heroic;
in
{
  options = {
    usrSettings.gaming.heroic.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Heroic launcher (~300MiB)";
    }; # end of usrSettings.gaming.heroic.enable
  }; # end of options

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.heroic
    ];
  }; # end of config
}
