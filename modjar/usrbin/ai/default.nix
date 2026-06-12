{
  config,
  lib,
  ...
}:
let
  cfg = config.usrSettings.ai;
in
{
  options = {
    usrSettings.ai = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.lm-studio = {
      enable = true;
    };
  };
}
