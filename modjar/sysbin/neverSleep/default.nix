{ lib, config, ... }:
let
  cfg = config.sysSettings.neverSleep;
in
{
  options.sysSettings.neverSleep.enable = lib.mkEnableOption "disable system idle sleep";

  config = lib.mkIf cfg.enable {
    services.logind.extraConfig = ''
      HandleSuspendKey=ignore
      HandleHibernateKey=ignore
      HandleLidSwitch=ignore
      HandleLidSwitchExternalPower=ignore
      HandleLidSwitchDocked=ignore
      IdleAction=ignore
    '';
    systemd.targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };
}
