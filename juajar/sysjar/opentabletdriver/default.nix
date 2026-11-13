# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: OpenTabletDriver for pen displays: GUI button/pressure config.
# -=-=-=-=-=-=-=-=-=-=-=
# bridge.nix turns this on when any usrset.tablets.<name>.driver is
# "opentabletdriver" (the default). Opt a tablet out with driver = "libinput".
#
# Mappings stay runtime-only by design: users launch `otd-gui` and changes land
# in ~/.config/OpenTabletDriver, no symlinks or config management. To version a
# profile instead, uncomment in a hjem user module (e.g.
# juajar/liijar/creation/default.nix):
#   files.".config/OpenTabletDriver/Settings.json".source = ./otd-settings.json;
#   files.".config/OpenTabletDriver/Profiles".source = ./otd-profiles;
#
# Blacklists hid-uclogic + wacom and starts otd-daemon as a user service, so it
# applies on the next boot.
{ config, lib, ... }:
let
  cfg = config.sysset.opentabletdriver;
in
{
  options = {
    sysset.opentabletdriver = {
      enable = lib.mkEnableOption "OpenTabletDriver (tablet button/pressure GUI; takes over the device)";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.opentabletdriver.enable = true;
  };
}
