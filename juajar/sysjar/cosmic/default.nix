# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: COSMIC desktop environment + optional greeter.
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  config,
  ...
}:
let
  cfg = config.sysset.cosmic;
in
{
  options = {
    sysset.cosmic = {
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

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services.desktopManager.cosmic.enable = true;
    })

    (lib.mkIf cfg.greeter {
      assertions = [
        {
          assertion = cfg.enable;
          message = "sysset.cosmic.greeter needs sysset.cosmic.enable = true.";
        }
      ];
      services.displayManager = {
        cosmic-greeter.enable = true;
        gdm.enable = lib.mkForce false; # one login manager: the greeter replaces GDM
      };
    })
  ];
}
