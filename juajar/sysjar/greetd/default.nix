# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: greetd + tuigreet terminal login menu.
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.sysset.greetd;
in
{
  options = {
    sysset.greetd.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable greetd + tuigreet terminal login menu (mutually exclusive with sysset.gdm)";
    };
  }; # end options

  config = lib.mkIf cfg.enable {
    # tuigreet lists sessions + users on tty1, no graphical greeter.
    # --sessions: NixOS has no /usr/share, point at the system session dir.
    # --remember/--remember-session: prefill last user + session, password only.
    # useTextGreeter: keeps boot-log spam from printing over the TUI.
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          user = "greeter";
          command = "${lib.getExe pkgs.tuigreet} --time --asterisks --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
        }; # end of default session
      }; # end of settings
    }; # end of services

    # gdm and greetd both claim display-manager.service
    assertions = [
      {
        assertion = !config.sysset.gdm.enable;
        message = "sysset.greetd and sysset.gdm are mutually exclusive";
      }
    ];
  }; # end config
}
