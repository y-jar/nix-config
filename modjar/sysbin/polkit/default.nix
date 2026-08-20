# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Polkit authentication agent + rules.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[polkit] =-=-=
# Enables the GNOME polkit authentication agent
# as a systemd user service. Prompts for a password
# when apps need elevated privileges.
# =-=-=[end polkit] =-=-=

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sysSettings.polkit;
in
{
  options.sysSettings.polkit = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable polkit authentication agent (gnome polkit)";
    }; # end of enable
  }; # end of sysSettings.polkit

  config = lib.mkIf cfg.enable {
    # [polkit system service]
    security.polkit.enable = true;

    # [polkit gnome auth agent (user service)]
    systemd.user.services.polkit-agent = {
      description = "PolicyKit Authentication by Gnome";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      }; # end of serviceConfig
    }; # end of polkit-agent
  }; # end of config
}
