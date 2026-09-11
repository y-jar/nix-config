# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: liijar hjem entry: auto-imports every app's hjem.nix + the .profile bus.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[liijar/hjem.nix] =-=-=
# Imported by juajar/hjemkey.nix via hjem.extraModules (hjem user scope).
# Every juajar/liijar/<app>/ directory that has a hjem.nix gets imported,
# plus the dirSetup bus (lines merged into the .profile by hjemkey).
# =-=-=[end liijar/hjem.nix] =-=-=
{ lib, ... }:

let
  dirContents = builtins.readDir ./.;

  appDirs = lib.filterAttrs (
    name: type:
    type == "directory"
    && builtins.pathExists (./. + "/${name}/hjem.nix")
    && name != "wmconfigs" # raw WM config assets, not a module
    && name != "shell" # shared shell data (aliases/functions), not a module
  ) dirContents;

  appPaths = map (name: ./. + "/${name}/hjem.nix") (builtins.attrNames appDirs);
in
{
  imports = [
    ./profile-bus.nix # hjemDotfiles.dirSetup (merged into .profile by hjemkey)
  ]
  ++ appPaths;
}
