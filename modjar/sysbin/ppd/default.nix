{ config, lib, ... }:

let
  cfg = config.sysSettings.powerprofiles;
in
{
  options = {
    sysSettings.powerprofiles = {
      enable = lib.mkEnableOption "Enable power profiles daemon";
    }; # end of powerprofiles
  }; # end of options

  config = lib.mkIf cfg.enable {
    services.power-profiles-daemon = {
      enable = true;
    }; # end of power-profiles-daemon
  }; # end of config
}
