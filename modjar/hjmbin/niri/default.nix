# =-=-=[niri] =-=-=
# Copies KDL config files and fuzzel scripts.
# ref: modjar/usrbin/WindowManager[niri]/, launcher[fuzzel]/scriptsbin/
# The desktop shell spawn + launcher/settings binds are gated on
# hjmSettings.niri.{shelljar,noctalia}.enable (mirrors the home-manager config).
# =-=-=[end niri] =-=-=

{
  config,
  lib,
  pkgs,
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

  shelljarEnabled = hjm.niri.shelljar.enable or false;
  noctaliaEnabled = hjm.niri.noctalia.enable or false;

  # exact bind lines in the static file that get swapped per shell
  dLine = ''Mod+D hotkey-overlay-title="[D]isplay Noctalia Launcher" { spawn-sh "noctalia-shell ipc call launcher toggle "; }'';
  sLine = ''Mod+S hotkey-overlay-title="Toggle Noctalia [S]ettings" { spawn "qs" "ipc" "-c" "noctalia-shell" "call" "settings" "toggle"; }'';

  shellBinds =
    if shelljarEnabled then
      {
        d = ''Mod+D hotkey-overlay-title="[D]isplay shelljar Launcher" { spawn-sh "shjctl toggleLauncher"; }'';
        s = ''Mod+S hotkey-overlay-title="Toggle [S]helljar Control Center" { spawn-sh "shjctl toggleControlCenter"; }'';
      }
    else if noctaliaEnabled then
      {
        d = dLine;
        s = sLine;
      }
    else
      {
        d = "    // Mod+D: no desktop shell enabled";
        s = "    // Mod+S: no desktop shell enabled";
      };

  generatedBindings = lib.replaceStrings [ dLine sLine ] [ shellBinds.d shellBinds.s ] (
    builtins.readFile (kdlDir + "/bindings.kdl")
  );

  generatedStartups =
    builtins.readFile (kdlDir + "/startups.kdl")
    + lib.optionalString shelljarEnabled ''
      spawn-at-startup "shelljar"
      // desktop shell (quickshell island shell) spawned by Bar[shelljar]
    ''
    + lib.optionalString (noctaliaEnabled && !shelljarEnabled) ''
      spawn-at-startup "noctalia-shell"
      // desktop shell spawned by Bar[noctalia]
    '';
in
{
  options = {
    hjmSettings.niri.shelljar = {
      enable = lib.mkEnableOption "shelljar (quickshell island shell) for niri";
    };
    hjmSettings.niri.noctalia = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true; # on by default so existing hosts keep noctalia until they swap shells
        description = "Enable the noctalia desktop shell for niri";
      }; # end of hjmSettings.niri.noctalia.enable
    };
  }; # end of options

  config = lib.mkIf hjm.niri.enable {
    hjemDotfiles.niriFiles = {
      config = kdlDir + "/config.kdl";
      base = kdlDir + "/base.kdl";
      bindings = pkgs.writeText "niri-bindings.kdl" generatedBindings;
      rules = kdlDir + "/rules.kdl";
      startups = pkgs.writeText "niri-startups.kdl" generatedStartups;
      hostInputs = targetKdlSource;
    };
  }; # end of config
}
