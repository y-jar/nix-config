# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Cinnamon desktop environment (system enable).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sysSettings.cinnamon;
in
{
  options = {
    sysSettings.cinnamon = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Cinnamon desktop (~800MiB)";
      }; # end of enable
    }; # end of cinnamon
  }; # end of options

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true; # Required to spin up the session handling
      desktopManager.cinnamon.enable = true; # Enable Cinnamon desktop environment
    }; # end of xserver
  }; # end of config
}
