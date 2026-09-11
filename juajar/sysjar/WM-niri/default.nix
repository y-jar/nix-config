# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Niri compositor (system-level enable).
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  config,
  ...
}:
let
  cfg = config.sysset.niri;
in
{
  options = {
    sysset.niri.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Niri (~20MiB)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;
  };
}
