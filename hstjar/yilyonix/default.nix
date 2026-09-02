# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host yilyonix: imports system + hardware + boot for this machine.
# -=-=-=-=-=-=-=-=-=-=-=
{
  inputs,
  hostnm,
  config,
  ...
}:

{
  imports = [
    ./system.nix # system configuration
    ./hardware-configuration.nix # hardware configuration
    ./boot.nix # boot settings
    ./autostart.nix # per-host autostart apps (Window Managers only)
  ];
}
