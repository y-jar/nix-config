# modules-jar/sys-bin/load-scripts.nix
{ pkgs, ... }:
let
  # =-=-=[Script Loader]
  mkScript = name: path: pkgs.writeShellScriptBin name (builtins.readFile path);

  # =-=-=[Scripts]
  # TEMPLATE: { name = "TEMPLATE"; path = ./scriptsbin/TEMPLATE.sh; }
  scriptList = [
    { name = "bldjar";      path = ./scriptsbin/bldjar.sh; }
    { name = "fixzsh";      path = ./scriptsbin/fixzsh.sh; }
    { name = "ytdl";        path = ./scriptsbin/ytdl.sh; }
    { name = "random-wall"; path = ./scriptsbin/random-wall.sh; }
    { name = "jwall";       path = ./scriptsbin/jwall.sh; }
  ]; # end of script list

  jarScripts = map (s: mkScript s.name s.path) scriptList; # dont touch me!
in
{
  config = {
    home.packages = jarScripts;
  }; # end of config
}
