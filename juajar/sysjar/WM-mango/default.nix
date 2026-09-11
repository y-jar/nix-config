# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: mango (mangowm) compositor (system-level enable).
# -=-=-=-=-=-=-=-=-=-=-=
{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.sysset.mango;
in
{
  imports = [
    inputs.mangowm.nixosModules.mango # provides programs.mango (package, portal, session entry)
  ];

  options = {
    sysset.mango.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable mango (~mangowm) compositor";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.mango.enable = true;

    # mango is not systemd-launched, so nothing activates the standard session
    # targets (niri gets this from niri.service BindsTo=graphical-session.target).
    # mango-session.target is started from mango's exec-once (startups.conf) and
    # pulls graphical-session.target in as a dependency — systemd refuses manual
    # starts of graphical-session.target itself.
    systemd.user.units."mango-session.target".text = ''
      [Unit]
      Description=mango graphical session
      Wants=graphical-session.target
      After=graphical-session.target
    '';
  };
}
