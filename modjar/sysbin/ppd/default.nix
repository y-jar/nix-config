{ config, lib, ... }:

let
  cfg = config.sysSettings.powerprofiles;
in
{
  options = {
    sysSettings.powerprofiles = {
      enable = lib.mkEnableOption "Enable power profiles daemon";
    };
  };

  config = lib.mkIf cfg.enable {
    services.power-profiles-daemon = {
      enable = true;
    };
  };
}
