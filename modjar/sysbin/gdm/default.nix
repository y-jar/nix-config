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
      extraPackages = with pkgs; [
        gdm-settings # GDM settings GUI
      ]; # end of extraPackages
    }; # end gdm
  }; # end config
}
