# modules-jar/sys-bin/load-scripts.nix
{ pkgs, ... }:
let
  # updates the system, configs, system, and such
  nru-ito = pkgs.writeShellScriptBin "nru" (builtins.readFile ../../res/scripts-bin/nru.sh);
  # This wraps the shell script into a var / pkgs
  bldjar-ito = pkgs.writeShellScriptBin "bldjar" (
    builtins.readFile ../../res/scripts-bin/build-jar.sh
  );
in
{
  config = {
    environment.systemPackages = [
      bldjar-ito # creates all jars in the system
      nru-ito # serves as a global updater [might be discontinued if nh is good]
    ]; # end of environment.systemPackages
  }; # end of config
}
