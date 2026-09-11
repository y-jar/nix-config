# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Bluetooth support (daemon + pairing tools).
# -=-=-=-=-=-=-=-=-=-=-=
{ lib, config, ... }:

let
  cfg = config.sysset.bluetooth;
in
{
  options = {
    sysset.bluetooth = {
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
