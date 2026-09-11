# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Power Profiles Daemon.
# -=-=-=-=-=-=-=-=-=-=-=
{ config, lib, ... }:

let
  cfg = config.sysset.powerprofiles;
in
{
  options = {
    sysset.powerprofiles = {
      enable = lib.mkEnableOption "Enable power profiles daemon";
    }; # end of powerprofiles
  }; # end of options

  config = lib.mkIf cfg.enable {
    services.power-profiles-daemon = {
      enable = true;
    }; # end of power-profiles-daemon
  }; # end of config
}
