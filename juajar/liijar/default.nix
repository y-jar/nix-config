# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Auto-imports all sibling liijar modules (don't edit logic).
# -=-=-=-=-=-=-=-=-=-=-=
# Same auto-importer as sysjar: pulls in every root .nix file (options.nix,
# profile-bus.nix) plus every app dir. App dirs must carry a default.nix;
# the data dir (shell/) doesn't, so it is skipped naturally. WM modules live in ../WMs.
{
  lib,
  ...
}:

let
  dirContents = builtins.readDir ./.;

  nixFiles = lib.filterAttrs (
    name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
  ) dirContents;

  subDirs = lib.filterAttrs (
    name: type: type == "directory" && builtins.pathExists (./. + "/${name}/default.nix")
  ) dirContents;

  filePaths = map (name: ./. + "/${name}") (builtins.attrNames nixFiles);
  dirPaths = map (name: ./. + "/${name}") (builtins.attrNames subDirs);
in
{
  imports = filePaths ++ dirPaths;
}
