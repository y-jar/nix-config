{ config, lib, pkgs, ... }:
let
  cfg = config.usrSettings.launcher;
  # =-=-=[Script Loader]
  mkScript = name: path: pkgs.writeShellScriptBin name (builtins.readFile path);

  # =-=-=[Scripts]
  # TEMPLATE: { name = "TEMPLATE"; path = ./scriptsbin/TEMPLATE.sh; }
  scriptList = [
    { name = "jsearch"; path = ./scriptsbin/searchweb.sh; }
  ]; # end of script list

  jarScripts = map (s: mkScript s.name s.path) scriptList; # dont touch me!
in
{
  config = lib.mkIf cfg.enable {
    home.packages = jarScripts; # dont touch me!
  }; # end of config
}
