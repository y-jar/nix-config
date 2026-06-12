{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.usrSettings.bluetooth;
in
{
  options = {
    usrSettings.bluetooth = {
      enable = lib.mkEnableOption "Enable bluetooth";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      blueman
    ]; # installs blueman
  }; # end of config
}
