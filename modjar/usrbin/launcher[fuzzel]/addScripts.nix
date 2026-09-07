# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Extra launcher helper scripts.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.launcher;
  # =-=-=[Script Loader]
  mkScript = name: path: pkgs.writeShellScriptBin name (builtins.readFile path);

  # =-=-=[Scripts]
  # Shared WM tool scripts live in resjar/wmconfigs/bin.
  scriptDir = ../../../resjar/wmconfigs/bin;
  # TEMPLATE: { name = "TEMPLATE"; path = <script>; }
  scriptList = [
    {
      name = "jsearch";
      path = scriptDir + "/jsearch.sh";
    }
    {
      name = "jpower";
      path = scriptDir + "/jpower.sh";
    }
    {
      name = "jemoji";
      path = scriptDir + "/jemoji.sh";
    }
  ]; # end of script list

  jarScripts = map (s: mkScript s.name s.path) scriptList; # dont touch me!
in
{
  config = lib.mkIf cfg.enable {
    home.packages = jarScripts; # dont touch me!
  }; # end of config
}
