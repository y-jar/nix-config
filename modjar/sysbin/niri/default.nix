{
  lib,
  config,
  ...
}:
let
  cfg = config.sysSettings.niri;
in
{
  options = {
    sysSettings.niri.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Niri";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;
  };
}
