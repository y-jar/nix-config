{ lib, ... }:

let
  dirContents = builtins.readDir ./.;

  nixFiles = lib.filterAttrs (
    name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
  ) dirContents;

  subDirs = lib.filterAttrs (name: type: type == "directory") dirContents;

  filePaths = map (name: ./. + "/${name}") (builtins.attrNames nixFiles);
  dirPaths = map (name: ./. + "/${name}") (builtins.attrNames subDirs);
in
{
  imports = filePaths ++ dirPaths;
}
