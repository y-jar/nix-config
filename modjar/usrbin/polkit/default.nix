{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.security.polkit;
in
{
  options = {
    security.polkit.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable polkit related things";
    }; # end of security.polkit.enable
  }; # end of options

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.polkit_gnome # polkit gnome integration
    ]; # end of home.packages
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "polkit-gnome-authentication-agent-1";
        Wants = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      }; # end of Unit
      Install = {
        WantedBy = [ "graphical-session.target" ];
      }; # end of Install
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      }; # end of Service
    }; # end of systemd.user.services.polkit-gnome-authentication-agent-1
  }; # end of config
}
