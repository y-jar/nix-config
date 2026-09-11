# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Fastfetch system-fetch config + ascii logos (home-manager side).
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
    home.packages = shared.packages;
    # link dem files! (home.file paths are home-relative)
    home.file = lib.mapAttrs (_: v: { source = v; }) shared.files;
  };
}
