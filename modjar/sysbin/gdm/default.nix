{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.sysSettings.gdm;
in
{
  options = {
    sysSettings.gdm.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable GDM display manager, Off if wanting headless";
    };
  }; # end options

  config = lib.mkIf cfg.enable {
    # this enables GDM, it is my fave, has to be picked via sysSettings.gdm.enable = true in sysSettings
    services.displayManager.gdm = {
      enable = true;
      banner = "=- Yil la kue mol loar -=";
    }; # end gdm
    environment.systemPackages = [
      pkgs.gdm-settings # GDM settings GUI
    ]; # end systemPackages
  }; # end config
}
