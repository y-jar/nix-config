# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Sleepy service: scheduled reboots/naps.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sysSettings.server.sleepyjar;
in
{
  options = {
    sysSettings.server.sleepyjar = {
      enable = lib.mkEnableOption "periodic server reboots (naps)";

      interval = lib.mkOption {
        type = lib.types.str;
        default = "weekly"; # Default fallback rule
        description = ''
          How often the server should reboot.
          Uses systemd calendar expressions (e.g., "daily", "weekly", "*-*-* 04:00:00").
        ''; # end of description
      }; # end of interval
    }; # end of sysSettings.server.sleepyjar
  }; # end of options

  config = lib.mkIf cfg.enable {
    # [This tells systemd WHEN to do the action]
    systemd.timers."periodic-nap" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.interval;
        Persistent = true; # Catches up if the server was offline during the window
        Unit = "periodic-nap.service";
      }; # end of timerConfig
    }; # end of systemd.timers."periodic-nap"

    # [This tells systemd WHAT to do when triggered]
    systemd.services."periodic-nap" = {
      description = "Trigger a scheduled system reboot nap";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/systemctl reboot"; # use da path to systemctl directly from the systemd package
      }; # end of serviceConfig
    }; # end of systemd.services."periodic-nap"
  }; # end of config
}
