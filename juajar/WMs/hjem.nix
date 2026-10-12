# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: WMs router (hjem side): auto-imports every <wm>/user.nix (don't edit logic).
# -=-=-=-=-=-=-=-=-=-=-=
# Loaded as a hjem extraModule by juajar/hjemkey.nix, next to ../liijar. The usrset.<wm>.*
# options themselves are still declared in liijar/options.nix (single sheet).
# See ./default.nix for the layout.
{ lib, ... }:

let
  dirs = lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./.);
  withFile = file: lib.filter (p: builtins.pathExists p) (map (n: ./. + "/${n}/${file}") (builtins.attrNames dirs));
in
{
  imports = withFile "user.nix";
}
