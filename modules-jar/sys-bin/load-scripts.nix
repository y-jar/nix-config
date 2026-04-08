# modules-jar/sys-bin/load-scripts.nix
{ pkgs, ... }:

let
  # This wraps the shell script into a var / pkgs
  bldjar = pkgs.writeShellScriptBin "bldjar" (builtins.readFile ../../scripts-bin/build-jar.sh);
in
{
  environment.systemPackages = [
    bldjar # creates all jars in the system
  ];
}