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
    sysSettings.niri = lib.mkEnableOption {
      description = "Enable Niri";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;
  };
}
