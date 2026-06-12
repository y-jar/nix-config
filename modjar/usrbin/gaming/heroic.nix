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
      description = "Enables Heroic";
    }; # end of usrSettings.gaming.heroic.enable
  }; # end of options

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.heroic
    ];
  }; # end of config
}
