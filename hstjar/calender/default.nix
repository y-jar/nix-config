# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host calender: imports system + hardware + boot for this machine.
# -=-=-=-=-=-=-=-=-=-=-=
{ ... }:

{
  imports = [
    ./system.nix # system configuration
    ./hardware-configuration.nix # hardware configuration
    ./boot.nix # boot settings
    ./autostart.nix # per-host autostart apps (Window Managers only)
    ./webapps.nix # per-host browser apps as desktop apps (webapps)
    ./mnt.nix # mounts the YilyoSeal drive
  ];
}
