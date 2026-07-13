{ config, lib, pkgs, ... }:
let
  cfg = config.usrSettings.ai;
  # =-=-=[Script Loader]
  mkScript = name: path: pkgs.writeShellScriptBin name (builtins.readFile path);

  # =-=-=[Scripts]
  # TEMPLATE: { name = "TEMPLATE"; path = ./scriptsbin/TEMPLATE.sh; }
  scriptList = [
    { name = "pull-models"; path = ./scriptsbin/pull-models.sh; }
    { name = "remove-models"; path = ./scriptsbin/remove-models.sh; }
  ]; # end of script list

  jarScripts = map (s: mkScript s.name s.path) scriptList; # dont touch me!
in
{
  config = lib.mkIf cfg.enable {
    home.packages = jarScripts; # dont touch me!
  }; # end of config
}
