# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: WMs router (NixOS side): auto-imports every <wm>/system.nix (don't edit logic).
# -=-=-=-=-=-=-=-=-=-=-=
# One dir per window manager, holding everything about it:
#
#   WMs/<wm>/system.nix   NixOS half   (sysset.<wm>.enable, programs.<wm>)  <- imported here
#   WMs/<wm>/user.nix     hjem half    (dotfiles + packages, usrset.<wm>.*)  <- imported by ./hjem.nix
#   WMs/<wm>/...          the raw config data (lua/kdl/conf, host-inputs/<host>.*)
#   WMs/lib.nix           shared helpers (host-inputs lookup)
#
# Add a WM = add a dir with a system.nix and/or user.nix. No registration.
# Wired in: flake.nix (mkJar modules) imports this file, hjemkey.nix imports ./hjem.nix.
{ lib, ... }:

let
  dirs = lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./.);
  withFile = file: lib.filter (p: builtins.pathExists p) (map (n: ./. + "/${n}/${file}") (builtins.attrNames dirs));
in
{
  imports = withFile "system.nix";
}
