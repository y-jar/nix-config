# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: mango (mangowm) compositor (system-level enable).
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.sysSettings.mango;
in
{
  imports = [
    inputs.mangowm.nixosModules.mango # provides programs.mango (package, portal, session entry)
  ];

  options = {
    sysSettings.mango.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable mango (~mangowm) compositor";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.mango.enable = true;
  };
}
