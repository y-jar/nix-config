# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Niri user config entry + host inputs.
# KDL configs live in resjar/wmconfigs/niri (single source of truth).
# Mod+D launcher follows the desktop shell: shelljar -> noctalia -> fuzzel.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  hostnm,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = config.usrSettings.niri;
  wmc = ../../../resjar/wmconfigs/niri; # shared niri wm configs (resjar)

  hostSpecificFile = wmc + "/host-inputs/${hostnm}.kdl"; # host-specific input
  targetKdlSource =
    if builtins.pathExists hostSpecificFile then
      hostSpecificFile
    else
      wmc + "/host-inputs/0-unknown.kdl";

  # Which desktop shell is running? Drives the Mod+S settings bind + Mod+D launcher.
  shelljarEnabled = config.usrSettings.shelljar.enable or false;
  noctaliaEnabled = config.usrSettings.noctalia.enable or false;

  # exact settings bind line in the static file that gets swapped per shell
  sLine = "    Mod+S hotkey-overlay-title=\"Toggle Noctalia [S]ettings\" { spawn \"qs\" \"ipc\" \"-c\" \"noctalia-shell\" \"call\" \"settings\" \"toggle\"; }";

  # exact browser bind line swapped to the per-host preferred browser.
  bLine = "    Mod+B hotkey-overlay-title=\"Open [B]rowser\" { spawn \"librewolf\"; }";
  browserCmd = config.usrSettings.browsers.default or "firefox";
  browserBind = "    Mod+B hotkey-overlay-title=\"Open [B]rowser\" { spawn \"${browserCmd}\"; }";

  # exact Mod+D launcher line in the static file, swapped per shell.
  dLine = "    Mod+D hotkey-overlay-title=\"[D]isplay Launcher (shelljar)\" { spawn-sh \"shjctl toggleLauncher\"; }";
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

  # exact Mod+S settings bind, swapped per shell.
  shellBindS =
    if shelljarEnabled then
      "    Mod+S hotkey-overlay-title=\"Toggle [S]helljar Control Center\" { spawn-sh \"shjctl toggleControlCenter\"; }"
    else if noctaliaEnabled then
      sLine
    else
      "    // Mod+S: no desktop shell enabled";
in
{
  options = {
    usrSettings.niri.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Niri window manager";
    }; # end of usrSettings.niri.enable
  }; # end of options

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "niri/config.kdl".source = wmc + "/config.kdl"; # base linker
      # [global] (shell/browser/launcher swapped per host + shell)
      "niri/bindings.kdl".text =
        lib.replaceStrings [ sLine bLine dLine ] [ shellBindS browserBind launcherBind ]
          (builtins.readFile (wmc + "/bindings.kdl"));
      "niri/base.kdl".source = wmc + "/base.kdl";
      "niri/rules.kdl".source = wmc + "/rules.kdl";
      "niri/startups.kdl".text =
        builtins.readFile (wmc + "/startups.kdl")
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
      # [channel pinning (jar-cap/mic-out) that only exists with the addon.]
      "niri/startups-audio.kdl".text =
        lib.optionalString (osConfig.sysSettings.audio.addon.enable or false)
          ''
            spawn-at-startup "qpwgraph"
            // Pin the jar-audio hub as default sink/source so "Desktop audio" streams
            // (discord, obs) always capture jar-cap.monitor = the full mix. Retries until
            // pipewire is up, so it survives reboots and sink re-plugs. Weird stuff
            spawn-sh-at-startup "until pactl info | grep -q 'Default Sink: jar-cap'; do pactl set-default-sink jar-cap; sleep 1; done"
            spawn-sh-at-startup "until pactl info | grep -q 'Default Source: mic-out'; do pactl set-default-source mic-out; sleep 1; done"
          '';
      # [host specific]
      "niri/host-inputs.kdl".source = targetKdlSource;
    }; # end of xdg.configFile
    home.packages = with pkgs; [
      xwayland-satellite # Xwayland outside the compositor
      wl-clipboard # Wayland copy/paste CLI
      brightnessctl # backlight control (shelljar BrightnessService)
    ];
  }; # end of config
}
