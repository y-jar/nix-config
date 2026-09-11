# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Fastfetch system-fetch config + ascii logos (hjem side).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.fastfetch;
  shared = import ./shared.nix { inherit pkgs; };
in
{
  config = lib.mkIf cfg.enable {
    packages = shared.packages;
    files = lib.mapAttrs (_: v: { source = v; }) shared.files;
  };
}
