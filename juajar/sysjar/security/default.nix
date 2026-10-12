# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Security baseline: polkit daemon + rtkit, each a toggle (on by default).
# -=-=-=-=-=-=-=-=-=-=-=
# The polkit DAEMON lives here; the optional gnome auth AGENT is ../polkit.
{ config, lib, ... }:
let
  cfg = config.sysset.security;
in
{
  options.sysset.security = {
    polkit.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Run the polkit daemon (many services and desktop apps need it).";
    };
    rtkit.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Run rtkit so audio and games can request realtime CPU priority.";
    };
  };

  config = {
    # mkDefault: a service that hard-requires polkit (libvirtd, gnome) can still turn it on
    security.polkit.enable = lib.mkDefault cfg.polkit.enable;
    security.rtkit.enable = lib.mkDefault cfg.rtkit.enable;
  };
}
