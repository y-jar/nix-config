# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host ziiemar: imports system + hardware + boot for this machine.
# -=-=-=-=-=-=-=-=-=-=-=
{
  inputs,
  hostnm,
  config,
  ...
}:
{
  imports = [
    ./boot.nix # boot settings
    ./hardware-configuration.nix # hardware configuration
    ./system.nix # loads the system part of the system, root loves me
    ./hardware-fix.nix # applies hardware fixes for the Gyro issue
    ./autostart.nix # per-host autostart apps (Window Managers only)
    ./webapps.nix # per-host browser apps as desktop apps (webapps)
  ];
}
