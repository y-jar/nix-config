# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Espanso daemon + Wayland security wrapper (system-level).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sysSettings.espanso;
in
{
  options = {
    sysSettings.espanso = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable espanso daemon + Wayland security wrapper (espanso-wayland)";
      }; # end of enable
    }; # end of sysSettings.espanso
  }; # end of options

  config = lib.mkIf cfg.enable {
    services.espanso = {
      enable = true;
      package = pkgs.espanso-wayland; # Wayland: module creates the security wrapper
    }; # end of services.espanso
  }; # end of config
}
