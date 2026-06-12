{ config, lib, ... }:

let
  cfg = config.sysSettings.tlp;
in
{
  options = {
    sysSettings.tlp = {
      enable = lib.mkEnableOption "Enable TLP daemon";
    };
  }; # end of tlp options

  config = lib.mkIf cfg.enable {
    services.tlp = {
      enable = true;
    }; # end of tlp
  }; # end of tlp config
}
