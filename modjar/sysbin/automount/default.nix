# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Auto-mount removable media via udisks2.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  ...
}:
let
  cfg = config.sysSettings.automount;
in
{
  options.sysSettings.automount = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable auto-mounting of removable media (udisks2)";
    };
  };

  config = lib.mkIf cfg.enable {
    services.udisks2.enable = true;
  };
}
