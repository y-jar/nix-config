{
  config,
  lib,
  ...
}:
let
  cfg = config.usrSettings.keepass;
in
{
  options = {
    usrSettings.keepass = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      }; # end of enable
    }; # end of usrSettings.keepass
  }; # end of options

  config = lib.mkIf cfg.enable {
    programs.keepass = {
      enable = true;
    };
  }; # end of config
}
