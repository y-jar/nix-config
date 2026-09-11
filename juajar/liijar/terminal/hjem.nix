# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem terminal: maps shared foot.ini + terminal packages.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.terminal;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{
  config = lib.mkIf cfg.enable {
    packages = shared.packages;
    files = lib.mapAttrs (_: v: { source = v; }) shared.files;
  }; # end of config
}
