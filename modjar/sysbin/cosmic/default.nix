{
  lib,
  config,
  ...
}:
let
  cfg = config.sysSettings.cosmic;
in
{
  options = {
    sysSettings.cosmic = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable COSMIC desktop environment";
      };
      greeter = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable COSMIC greeter (login manager, disables GDM if both enabled)";
      };
    };
  };

  config = {
    services.desktopManager.cosmic.enable = cfg.enable;
    services.displayManager.cosmic-greeter.enable = cfg.greeter;
    services.displayManager.gdm.enable = lib.mkIf cfg.greeter (lib.mkForce false);
  };
}
