# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Niri KDL config generation.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[niri] =-=-=
# Copies the KDL config files (from liijar/wmconfigs/niri, shared with the
# old home-manager side). The desktop shell spawn + launcher/settings binds are
# gated on usrset.niri.{shelljar,noctalia}.enable (mirrors the old home-manager
# config). Mod+D launcher follows the desktop shell: shelljar -> noctalia -> fuzzel.
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
  hjm = config.usrset;

  wmc = ../wmconfigs/niri; # shared niri wm configs (liijar)
  kdlDir = wmc;
  hostInputsDir = wmc + "/host-inputs";

  # [select host-specific input file]
  hostSpecificFile = hostInputsDir + "/${hostnm}.kdl";
  targetKdlSource =
    if builtins.pathExists hostSpecificFile then hostSpecificFile else hostInputsDir + "/0-unknown.kdl";

  shelljarEnabled = hjm.niri.shelljar.enable or false;
  noctaliaEnabled = hjm.niri.noctalia.enable or false;

  # exact settings bind line in the static file that gets swapped per shell
  # (double-quoted + leading spaces: ''-strings strip indentation and would
  # never match the indented static line, silently no-op'ing the swap)
  sLine = "    Mod+S hotkey-overlay-title=\"Toggle Noctalia [S]ettings\" { spawn \"qs\" \"ipc\" \"-c\" \"noctalia-shell\" \"call\" \"settings\" \"toggle\"; }";

  # exact browser bind line swapped to the per-host preferred browser.
  bLine = "    Mod+B hotkey-overlay-title=\"Open [B]rowser\" { spawn \"librewolf\"; }";
  browserCmd = hjm.browsers.default or "firefox";
  browserBind = "    Mod+B hotkey-overlay-title=\"Open [B]rowser\" { spawn \"${browserCmd}\"; }";

  # exact Mod+D launcher line swapped per shell.
  dLine = "    Mod+D hotkey-overlay-title=\"[D]isplay Launcher (shelljar)\" { spawn-sh \"shjctl toggleLauncher $(niri msg -j focused-output | jq -r .name)\"; }";
  dShellBind = dLine; # shelljar launcher
  dNoctaliaBind = "    Mod+D hotkey-overlay-title=\"[D]isplay Noctalia Launcher\" { spawn \"qs\" \"ipc\" \"-c\" \"noctalia-shell\" \"call\" \"launcher\" \"toggle\"; }";
  dFuzzelBind = "    Mod+D hotkey-overlay-title=\"[D]isplay Launcher (fuzzel)\" { spawn \"fuzzel\"; }";
  launcherBind =
    if shelljarEnabled then
      dShellBind
    else if noctaliaEnabled then
      dNoctaliaBind
    else
      dFuzzelBind;

  shellBindS =
    if shelljarEnabled then
      "    Mod+S hotkey-overlay-title=\"Toggle [S]helljar Control Center\" { spawn-sh \"shjctl toggleControlCenter $(niri msg -j focused-output | jq -r .name)\"; }"
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
      osConfig.sysset.autostart.commands or [ ]
    )
    + lib.optionalString shelljarEnabled ''
      spawn-at-startup "shelljar"
      // desktop shell (quickshell island shell) spawned by WM-niri
    ''
    + lib.optionalString (noctaliaEnabled && !shelljarEnabled) ''
      spawn-at-startup "noctalia-shell"
      // desktop shell spawned by WM-niri
    '';

  # audio channel pinning, generated if the audio addon is enabled.
  generatedStartupsAudio = lib.optionalString (osConfig.sysset.audio.addon.enable or false) ''
    spawn-at-startup "qpwgraph"
    // Pin the jar-audio hub as default sink/source so "Desktop audio" streams
    // (discord, obs) always capture jar-cap.monitor = the full mix. Retries until
    // pipewire is up, so it survives reboots and sink re-plugs. Weird stuff
    spawn-sh-at-startup "until pactl info | grep -q 'Default Sink: jar-cap'; do pactl set-default-sink jar-cap; sleep 1; done"
    spawn-sh-at-startup "until pactl info | grep -q 'Default Source: mic-out'; do pactl set-default-source mic-out; sleep 1; done"
  '';
in
{

  config = lib.mkIf hjm.niri.enable {
    packages =
      with pkgs;
      [
        # niri packages (folded from hjmbin/packages.nix bucket)
        wayshot
        wl-clipboard
        wlr-randr
        playerctl
        brightnessctl
        libnotify
        dunst
        grim
        slurp
        wf-recorder
      ]
      # install the desktop shell exactly when it would be spawned
      ++ lib.optionals shelljarEnabled [
        inputs.shelljar.packages.${pkgs.stdenv.hostPlatform.system}.default # spawned by generatedStartups when shelljar is the shell
      ]
      ++ lib.optionals (noctaliaEnabled && !shelljarEnabled) [
        pkgs.noctalia-shell # spawned by generatedStartups when noctalia is the shell
      ];
    files = {
      ".config/niri/config.kdl".source = kdlDir + "/config.kdl";
      ".config/niri/base.kdl".source = kdlDir + "/base.kdl";
      ".config/niri/bindings.kdl".source = pkgs.writeText "niri-bindings.kdl" generatedBindings;
      ".config/niri/rules.kdl".source = kdlDir + "/rules.kdl";
      ".config/niri/startups.kdl".source = pkgs.writeText "niri-startups.kdl" generatedStartups;
      ".config/niri/startups-audio.kdl".source =
        pkgs.writeText "niri-startups-audio.kdl" generatedStartupsAudio;
      ".config/niri/host-inputs.kdl".source = targetKdlSource;
    };
  }; # end of config
}
