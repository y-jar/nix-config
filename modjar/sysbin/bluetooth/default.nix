{ lib, config, ... }:

let
  cfg = config.sysSettings.bluetooth;
in
{
  options = {
    sysSettings.bluetooth = {
      enable = lib.mkEnableOption "Enable bluetooth";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
    };
    services.blueman.enable = true;
  }; # end of bluetooth config
}
