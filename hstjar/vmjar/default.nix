# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host vmjar: imports system + hardware + boot for this machine.
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
  ];
}
