# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: LocalSend cross-device file sharing.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sysSettings.localsend;
in
{
  options = {
    sysSettings.localsend = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the localsend service. with some firewall stuff :)";
      };
    }; # end of localsend options
  }; # end of options

  # local send
  config = lib.mkIf cfg.enable {
    programs.localsend = {
      enable = true;
      package = pkgs.localsend;
      openFirewall = true;
    }; # end of localsend
  }; # end of localsend config
}
