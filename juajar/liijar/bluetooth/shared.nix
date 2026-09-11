# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Blueman GUI (user-level bluetooth tool) both backends.
# -=-=-=-=-=-=-=-=-=-=-=
{
  cfg,
  lib,
  pkgs,
  ...
}:
{
  packages = lib.optionals cfg.enable [ pkgs.blueman ];
}
