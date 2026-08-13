# =-=-=[niri] =-=-=
# Copies KDL config files and fuzzel scripts.
# ref: modjar/usrbin/WindowManager[niri]/, launcher[fuzzel]/scriptsbin/
# =-=-=[end niri] =-=-=

{
  config,
  lib,
  hostnm,
  ...
}:
let
  hjm = config.hjmSettings;

  kdlDir = ./kdl-configs;
  hostInputsDir = ./host-inputs;
  scriptsDir = ./scripts;

  # [select host-specific input file]
  hostSpecificFile = hostInputsDir + "/${hostnm}.kdl";
  targetKdlSource =
    if builtins.pathExists hostSpecificFile then hostSpecificFile else hostInputsDir + "/0-unknown.kdl";
in
{
  config = lib.mkIf hjm.niri.enable {
    hjemDotfiles.niriFiles = {
      config = kdlDir + "/config.kdl";
      base = kdlDir + "/base.kdl";
      bindings = kdlDir + "/bindings.kdl";
      rules = kdlDir + "/rules.kdl";
      startups = kdlDir + "/startups.kdl";
      hostInputs = targetKdlSource;
    };
  };
}
