# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Disable system idle sleep.
# -=-=-=-=-=-=-=-=-=-=-=
{ lib, config, ... }:
let
  cfg = config.sysSettings.neverSleep;
in
{
  options.sysSettings.neverSleep.enable = lib.mkEnableOption "disable system idle sleep";

  config = lib.mkIf cfg.enable {
    services.logind.settings.Login = {
      HandleSuspendKey = "ignore";
      HandleHibernateKey = "ignore";
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
      IdleAction = "ignore";
    };
    systemd.targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };
}
