# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Installs system management helper scripts (nru/updatejar).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sysset.systemScripts;

  # =-=-=[Script Loader]
  mkScript = name: path: pkgs.writeShellScriptBin name (builtins.readFile path);

  # =-=-=[Scripts]
  # TEMPLATE: { name = "TEMPLATE"; path = ./scriptsbin/TEMPLATE.sh; }
  scriptList = [
    {
      name = "nru";
      path = ./scriptsbin/nru.sh;
    }
    {
      name = "updatejar";
      path = ./scriptsbin/updatejar.sh;
    }
  ]; # end of script list

  jarScripts = map (s: mkScript s.name s.path) scriptList; # dont touch me!
in
{
  options.sysset.systemScripts.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Install the system helper scripts (nru, updatejar).";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = jarScripts;
  }; # end of config
}
