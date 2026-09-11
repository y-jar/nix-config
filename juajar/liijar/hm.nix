# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: liijar home-manager entry: auto-imports every app's hm.nix.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/hm.nix] =-=-=
# Imported by juajar/homekey.nix into the home-manager user scope.
# Every juajar/liijar/<app>/ directory that has an hm.nix gets imported.
# (App dirs can also carry sibling files + shared.nix — those are imported
# by the app's own hm.nix/hjem.nix, never by this auto-importer.)
# =-=-=[end liijar/hm.nix] =-=-=
{ lib, ... }:

let
  dirContents = builtins.readDir ./.;

  appDirs = lib.filterAttrs (
    name: type:
    type == "directory"
    && builtins.pathExists (./. + "/${name}/hm.nix")
    && name != "wmconfigs" # raw WM config assets, not a module
    && name != "shell" # shared shell data (aliases/functions), not a module
  ) dirContents;

  appPaths = map (name: ./. + "/${name}/hm.nix") (builtins.attrNames appDirs);
in
{
  imports = appPaths;
}
