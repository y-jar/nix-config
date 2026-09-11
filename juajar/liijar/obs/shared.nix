# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: OBS shared data: obs-studio package.
# -=-=-=-=-=-=-=-=-=-=-=
# (the six HM plugins stay HM-side hjem hosts never had them)
{
  cfg,
  pkgs,
  lib,
  ...
}:
{
  packages = [ pkgs.obs-studio ]; # end of packages
}
