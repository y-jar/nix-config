# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: blueman GUI (user-level bluetooth tool).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.bluetooth;

  # blueman, gated on the host sheet toggle
  bluetoothPackages = lib.optionals cfg.enable [ pkgs.blueman ]; # end of bluetoothPackages
in
{
  config = {
    packages = bluetoothPackages; # installs blueman
  }; # end of config
}
