{ config, lib, ... }:

let
  cfg = config.sysSettings.tlp;
in
{
  options = {
    sysSettings.tlp = {
      enable = lib.mkEnableOption "Enable TLP daemon";

      startChargeThreshold = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "Start charge threshold for BAT0 (0 = always charge)";
      };

      stopChargeThreshold = lib.mkOption {
        type = lib.types.int;
        default = 100;
        description = "Stop charge threshold for BAT0 (100 = no cap, 80 = cap at 80%)";
      };
    }; # end of tlp options
  }; # end of options

  config = lib.mkIf cfg.enable {
    services.tlp = {
      enable = true;
      # lets see if these even work with some of these hosts
      settings = {
        START_CHARGE_THRESH_BAT0 = cfg.startChargeThreshold;
        STOP_CHARGE_THRESH_BAT0 = cfg.stopChargeThreshold;
      };
    }; # end of tlp

    services.power-profiles-daemon.enable = lib.mkForce false;
  }; # end of config
}
