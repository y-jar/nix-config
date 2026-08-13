# modules-jar/sys-bin/load-scripts.nix
{ pkgs, ... }:
let
  # =-=-=[Script Loader]
  mkScript = name: path: pkgs.writeShellScriptBin name (builtins.readFile path);

  # =-=-=[Scripts]
  # TEMPLATE: { name = "TEMPLATE"; path = ./scriptsbin/TEMPLATE.sh; }
  scriptList = [
    {
      name = "nhu";
      path = ./scriptsbin/nhu.sh;
    }
    {
      name = "nru";
      path = ./scriptsbin/nru.sh;
    }
  ]; # end of script list

  jarScripts = map (s: mkScript s.name s.path) scriptList; # dont touch me!
in
{
  config = {
    environment.systemPackages = jarScripts;
  }; # end of config
}
