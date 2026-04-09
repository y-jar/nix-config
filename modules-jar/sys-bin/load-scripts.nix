# modules-jar/sys-bin/load-scripts.nix
{ pkgs, ... }:

let
  # updates the system, configs, system, and such
  nru-ito = pkgs.writeShellScriptBin "nru" (builtins.readFile ../../scripts-bin/nrt.sh);
  # This wraps the shell script into a var / pkgs
  bldjar-ito = pkgs.writeShellScriptBin "bldjar" (builtins.readFile ../../scripts-bin/build-jar.sh);
in
{
  environment.systemPackages = [
    bldjar-ito # creates all jars in the system
    nru-ito
  ];
}