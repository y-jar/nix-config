# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Dev toolchain: dotnet/node/gcc/go + nix + sql tools.
# -=-=-=-=-=-=-=-=-=-=-=
# Package buckets come from ./shared.nix (per-sub-toggle gated there).
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrset.dev;
  shared = import ./shared.nix { inherit cfg pkgs lib; };
in
{
  config = lib.mkIf cfg.enable {
    home.packages = shared.packages; # end of home.packages
  }; # end of config
}
