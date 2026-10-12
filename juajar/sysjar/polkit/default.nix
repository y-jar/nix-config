# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Polkit authentication AGENT (user service); the daemon lives in ../security.
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
  cfg = config.sysset.polkit;
in
{
  options.sysset.polkit = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Run the gnome polkit authentication AGENT as a user service. The polkit daemon itself is always on (see ../security).";
    }; # end of enable
  }; # end of sysset.polkit

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.security.polkit.enable;
        message = "sysset.polkit (the auth agent) needs the polkit daemon: set sysset.security.polkit.enable = true.";
      }
    ];

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
