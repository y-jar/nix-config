# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: hjem: niri kdl config generation.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[niri] =-=-=
# Copies the KDL config files (from resjar/wmconfigs/niri, shared with usrbin).
# The desktop shell spawn + launcher/settings binds are gated on
# hjmSettings.niri.{shelljar,noctalia}.enable (mirrors the home-manager config).
# Mod+D launcher follows the desktop shell: shelljar -> noctalia -> fuzzel.
# =-=-=[end niri] =-=-=

{
  config,
  lib,
  pkgs,
  inputs,
  osConfig,
  hostnm,
  ...
}:
let
  hjm = config.hjmSettings;

  wmc = ../../../resjar/wmconfigs/niri; # shared niri wm configs (resjar)
  kdlDir = wmc;
  hostInputsDir = wmc + "/host-inputs";

  # [select host-specific input file]
  hostSpecificFile = hostInputsDir + "/${hostnm}.kdl";
  targetKdlSource =
    if builtins.pathExists hostSpecificFile then hostSpecificFile else hostInputsDir + "/0-unknown.kdl";

  shelljarEnabled = hjm.niri.shelljar.enable or false;
  noctaliaEnabled = hjm.niri.noctalia.enable or false;

  # exact settings bind line in the static file that gets swapped per shell
  sLine = ''Mod+S hotkey-overlay-title="Toggle Noctalia [S]ettings" { spawn "qs" "ipc" "-c" "noctalia-shell" "call" "settings" "toggle"; }'';

  # exact browser bind line swapped to the per-host preferred browser.
  bLine = ''Mod+B hotkey-overlay-title="Open [B]rowser" { spawn "librewolf"; }'';
  browserCmd = hjm.browsers.default or "firefox";
  browserBind = ''Mod+B hotkey-overlay-title="Open [B]rowser" { spawn "${browserCmd}"; }'';

  # exact Mod+D launcher line swapped per shell.
  dLine = ''Mod+D hotkey-overlay-title="[D]isplay Launcher (shelljar)" { spawn-sh "shjctl toggleLauncher"; }'';
  dShellBind = dLine; # shelljar launcher
  dNoctaliaBind = ''Mod+D hotkey-overlay-title="[D]isplay Noctalia Launcher" { spawn "qs" "ipc" "-c" "noctalia-shell" "call" "launcher" "toggle"; }'';
  dFuzzelBind = ''Mod+D hotkey-overlay-title="[D]isplay Launcher (fuzzel)" { spawn "fuzzel"; }'';
  launcherBind =
    if shelljarEnabled then
      dShellBind
    else if noctaliaEnabled then
      dNoctaliaBind
    else
      dFuzzelBind;

  shellBindS =
    if shelljarEnabled then
      ''Mod+S hotkey-overlay-title="Toggle [S]helljar Control Center" { spawn-sh "shjctl toggleControlCenter"; }''
    else if noctaliaEnabled then
      sLine
    else
      "    // Mod+S: no desktop shell enabled";

  generatedBindings =
    lib.replaceStrings [ sLine bLine dLine ] [ shellBindS browserBind launcherBind ]
      (builtins.readFile (kdlDir + "/bindings.kdl"));

  generatedStartups =
    builtins.readFile (kdlDir + "/startups.kdl")
    + lib.concatMapStringsSep "" (c: "spawn-at-startup \"${c}\"\n") (
      osConfig.sysSettings.autostart.commands or [ ]
    )
    + lib.optionalString shelljarEnabled ''
      spawn-at-startup "shelljar"
      // desktop shell (quickshell island shell) spawned by Bar[shelljar]
    ''
    + lib.optionalString (noctaliaEnabled && !shelljarEnabled) ''
      spawn-at-startup "noctalia-shell"
      // desktop shell spawned by Bar[noctalia]
    '';

  # audio channel pinning, generated if the audio addon is enabled.
  generatedStartupsAudio = lib.optionalString (osConfig.sysSettings.audio.addon.enable or false) ''
    spawn-at-startup "qpwgraph"
    // Pin the jar-audio hub as default sink/source so "Desktop audio" streams
    // (discord, obs) always capture jar-cap.monitor = the full mix. Retries until
    // pipewire is up, so it survives reboots and sink re-plugs. Weird stuff
    spawn-sh-at-startup "until pactl info | grep -q 'Default Sink: jar-cap'; do pactl set-default-sink jar-cap; sleep 1; done"
    spawn-sh-at-startup "until pactl info | grep -q 'Default Source: mic-out'; do pactl set-default-source mic-out; sleep 1; done"
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
    # install the desktop shell exactly when it would be spawned
    packages =
      lib.optionals shelljarEnabled [
        inputs.shelljar.packages.${pkgs.stdenv.hostPlatform.system}.default # spawned by generatedStartups when shelljar is the shell
      ]
      ++ lib.optionals (noctaliaEnabled && !shelljarEnabled) [
        pkgs.noctalia-shell # spawned by generatedStartups when noctalia is the shell
      ];
    hjemDotfiles.niriFiles = {
      config = kdlDir + "/config.kdl";
      base = kdlDir + "/base.kdl";
      bindings = pkgs.writeText "niri-bindings.kdl" generatedBindings;
      rules = kdlDir + "/rules.kdl";
      startups = pkgs.writeText "niri-startups.kdl" generatedStartups;
      startupsAudio = pkgs.writeText "niri-startups-audio.kdl" generatedStartupsAudio;
      hostInputs = targetKdlSource;
    };
  }; # end of config
}
